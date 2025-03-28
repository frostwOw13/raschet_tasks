

// ==== УНИВЕРСАЛЬНЫЕ ПРОЦЕДУРЫ ====

// Универсальная процедура заполнения набора записей
Процедура ЗаполнитьНаборЗаписей(ТекстЗапроса, ДокументСсылка, НаборЗаписей) Экспорт
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
	КонецЦикла;
КонецПроцедуры

// Универсальная расчетная процедура
Процедура РассчитатьЗаписиРегистраРасчета(НаборЗаписей, Выборка) Экспорт
	
	// Обходим в цикле выборку необходимых данных:
	Пока Выборка.Следующий() Цикл
		Результат = 0;  // обнуляем промежуточную переменную
		//  Получаем рассчитываемую запись регистра 
		//   из набора записей по индексу:
		ЗаписьРегистра = НаборЗаписей[Выборка.НомерСтроки - 1];
		//  Реализуем расчетные формулы 
		//   для каждого имеющегося способа расчета; 
		//   результат запоминаем в 
		//   промежуточной переменной Результат:
        Если Выборка.СпособРасчета = Перечисления.СпособыРасчета.ПоОкладу Тогда
            Если Выборка.НормаВремени > 0 Тогда
                Результат = ЗаписьРегистра.Размер * Выборка.Отработано / Выборка.НормаВремени;     
            КонецЕсли;
            
        // часовой тариф
        ИначеЕсли Выборка.СпособРасчета = Перечисления.СпособыРасчета.ЧасовойТариф Тогда
            Если Выборка.НормаВремени > 0 Тогда
                Результат = ЗаписьРегистра.Размер * Выборка.Отработано;     
            КонецЕсли;    
        
        // свободный выход
        ИначеЕсли Выборка.СпособРасчета = Перечисления.СпособыРасчета.СвободныйВыход Тогда
            ПроцентОтработанногоВремени = Выборка.Отработано / Выборка.НормаВремени * 100;
            Если ПроцентОтработанногоВремени >= 80 Тогда
                Результат = ЗаписьРегистра.Размер * Выборка.Отработано * 1.1;
            Иначе
                Результат = ЗаписьРегистра.Размер * Выборка.Отработано;
            КонецЕсли;
            
        // прогул
        ИначеЕсли Выборка.СпособРасчета = Перечисления.СпособыРасчета.ШтрафЗаПрогул Тогда                                     
            Результат = - (ЗаписьРегистра.Размер * Выборка.Отработано);
            
        // процентом
        ИначеЕсли Выборка.СпособРасчета = Перечисления.СпособыРасчета.Процентом Тогда
            Результат = ЗаписьРегистра.Размер * Выборка.СуммаБазы / 100; 
            
        // фиксировано
        ИначеЕсли Выборка.СпособРасчета = Перечисления.СпособыРасчета.Фиксированно Тогда
            Результат = ЗаписьРегистра.Размер;
            
        // пропорционально времени
        ИначеЕсли Выборка.СпособРасчета = Перечисления.СпособыРасчета.ПропорциональноВремени Тогда
            Результат = Выборка.СуммаБазы * Выборка.Отработано / Выборка.НормаВремени; 
            
            
        КонецЕсли;
        // Помещаем результат в запись регистра:
		ЗаписьРегистра.Результат = Результат * ?(ЗаписьРегистра.Сторно, -1, 1);
	КонецЦикла;
КонецПроцедуры
