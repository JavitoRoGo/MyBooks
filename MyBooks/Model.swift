//
//  Model.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 2/5/21.
//

import UIKit
import Charts

// MARK: - Book data type and structure

struct Books: Codable, Identifiable, Hashable {
    // Codable permite codificar desde y hacia los json
    // Identifiable permite hacer indexación desde un valor id
    // Hashable hace que el sistema idetifique cada instancia de forma única, con la función hash
    let id: Int
    var author: String
    var bookTitle: String
    var originalTitle: String
    var publisher: String
    var city: String
    var edition: Int
    var editionYear: Int
    var writingYear: Int
    var type: Type
    var isbn1: Int
    var isbn2: Int
    var isbn3: Int
    var isbn4: Int
    var isbn5: Int
    var pages: Int
    var height: Double
    var width: Double
    var thickness: Double
    var weight: Int
    var price: Double
    var place: Place
    var owner: Owner
    var status: ReadingStatus
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum Type: String, Codable, CaseIterable {
    // Codable para que cuadre con el struct
    // CaseIterable permite acceder a los case como un array, con su índice
    case hardcover = "Cartoné"
    case pocket = "Rústica"
    case flapPocket = "Rústica con solapas"
}
enum Place: String, Codable, CaseIterable {
    case a1 = "A1", a2 = "A2", a3 = "A3", a4 = "A4", a5 = "A5"
    case b1 = "B1", b2 = "B2", b3 = "B3", b4 = "B4", b5 = "B5"
    case c1 = "C1", c2 = "C2", c3 = "C3", c4 = "C4", c5 = "C5", c6 = "C6", c7 = "C7", c8 = "C8"
    case d1 = "D1", d2 = "D2", d3 = "D3", d4 = "D4", d5 = "D5", d6 = "D6", d7 = "D7", d8 = "D8"
    case lp = "LP", pll = "PLL", tf = "TF"
}
enum Owner: String, Codable, CaseIterable {
    case javi = "Javi"
    case aurora = "Aurora"
    case lucas = "Lucas"
    case comun = "Común"
}

enum ReadingStatus: String, Codable, CaseIterable {
    case notRead = "No leído"
    case read = "Leído"
    case registered = "Registrado"
    case consulting = "Consultas"
    case noStatus = "Desconocido"
}

// MARK: - Book model data

struct BooksModel {
    // Este struct es la lógica de los datos, y se pone aquí en el modelo y no en viewcontroller. Es la carga de la información
    
    // Creamos una variable con un array de tipo Books donde estarán los datos, y otra con el total
    var books: [Books] {
        didSet {
            saveToJson()
            totalBooks = books.count
        }
    }
    var totalBooks: Int
    
    // Inicializador para cargar los datos
    init() {
        guard var url = Bundle.main.url(forResource: "ALLBOOKS", withExtension: "json") else {
            books = []
            totalBooks = 0
            return
        }
        let documents = getDocumentsDirectory()
        let file = documents.appendingPathComponent("ALLBOOKS").appendingPathExtension("json")
        if FileManager.default.fileExists(atPath: file.path) {
            url = file
            print("Carga inicial desde archivo: \n" + file.absoluteString)
        } else { print("Carga inicial desde Bundle") }
        // do-try-catch para cargar los datos
        do {
            let json = try Data(contentsOf: url) //datos cargados en memoria
            books = try JSONDecoder().decode([Books].self, from: json) //extraer los datos
            totalBooks = books.count
        } catch {
            print("Error en la carga \(error)")
            books = []
            totalBooks = 0
        }
    }
    
    func saveToJson() {
        // Get the url of json in document directory
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        let fileURL = documentPath.appendingPathComponent("ALLBOOKS.json")
        // Transform array into data and save it into file
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(books)
            try data.write(to: fileURL)
            print("Grabación correcta")
            print(fileURL.absoluteString) //para obtener la ruta al archivo
        } catch {
            print("Error en la grabación \(error)")
        }
    }
    
    mutating func deleteBook(booksArray: [Books], indexPath: IndexPath) {
        let book = booksArray[indexPath.row]
        books.removeAll(where: { $0.id == book.id })
    }
    
    mutating func updateBook(book: Books) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[index] = book
    }
    
    // Número de lugares para el número de celdas (tabla general)
    func numOfPlaces() -> Int {
        Place.allCases.count
    }
    
    // Nombre del lugar para cada celda de la tabla general
    func placeName(indexPath: IndexPath) -> String {
        Place.allCases.reversed()[indexPath.row].rawValue
    }
    
    // Número de libros por lugar para el subtítulo de cada celda (tabla general)
    func numBooksAtPlace(indexPath: IndexPath) -> Int {
        //se crea un place según la section introducida y se busca dentro del array de allCases del enum Place
        let place = Place.allCases.reversed()[indexPath.row]
        //con ese place se filtran todos los datos en books que coincidan según el enum Place, y se cuenta
        return books.filter { $0.place == place }.count
    }
    
    // Recuperar datos por lugar (esta función recupera en un array los datos de cada case de Place)
    func booksInPlace(place: Place) -> [Books] {
        books.filter { $0.place == place }
    }
    // Selecciona un libro entre los buscados según lugar, para mostrar luego el detalle
    func queryBook(place: Place, indexPath: IndexPath) -> Books {
        let booksArray = booksInPlace(place: place)
        let selectedBook = booksArray.reversed()[indexPath.row]
        let book = books.filter { $0.id == selectedBook.id }.first!
        return book
    }
    
    // Devuelve la imagen según el estado
    func imageStatus(_ book: Books) -> UIImage {
        switch book.status {
        case .notRead:
            return UIImage(systemName: "bookmark.slash")!.withTintColor(.systemRed).withRenderingMode(.alwaysOriginal)
        case .read:
            return UIImage(systemName: "book")!.withTintColor(.systemGreen).withRenderingMode(.alwaysOriginal)
        case .registered:
            return UIImage(systemName: "paperclip")!
        case .consulting:
            return UIImage(systemName: "text.book.closed")!.withTintColor(.systemBrown).withRenderingMode(.alwaysOriginal)
        case .noStatus:
            return UIImage(systemName: "questionmark.app")!.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        }
    }
    
    func searchBook(text: String, scope: Int) -> [Books] {
        if scope == 0 {
            return books.filter { $0.bookTitle.lowercased().contains(text) }
        } else if scope == 1 {
            return books.filter { $0.author.lowercased().contains(text) }
        } else if scope == 2 {
            return books.filter { $0.status.rawValue.lowercased().contains(text) }
        } else {
            fatalError()
        }
    }
    
    func compareExistingData(tag: Int, text: String) -> (num: Int, dataSet: Set<String>) {
        var dataTotalArray = [String]()
        var foundBookArray = [Books]()
        if tag == 0 {
            foundBookArray = books.filter { $0.author.lowercased().contains(text.lowercased()) }
            for book in foundBookArray {
                dataTotalArray.append(book.author)
            }
        } else if tag == 1 {
            foundBookArray = books.filter { $0.publisher.lowercased().contains(text.lowercased()) }
            for book in foundBookArray {
                dataTotalArray.append(book.publisher)
            }
        } else {
            foundBookArray = books.filter { $0.city.lowercased().contains(text.lowercased()) }
            for book in foundBookArray {
                dataTotalArray.append(book.city)
            }
        }
        
        let setWithData = Set(dataTotalArray)
        return (setWithData.count, setWithData)
    }
    
}



// MARK: - Statistics type and structure

struct StatisticsModel {
    
    // Datos globales
    func globalPages(_ books: [Books]) -> (total: Int, mean: Int) {
        var total = 0
        for book in books {
            total += book.pages
        }
        let mean = total / books.count
        return (total, mean)
    }
    
    func globalPrice(_ books: [Books]) -> (total: Double, mean: Double) {
        var total = 0.0
        for book in books {
            total += book.price
        }
        let mean = total / Double(books.count)
        return (total, mean)
    }
    
    func globalThickness(_ books: [Books]) -> (total: Double, mean: Double) {
        var total = 0.0
        for book in books {
            total += book.thickness
        }
        let mean = total / Double(books.count)
        return (total, mean)
    }
    
    func globalWeight(_ books: [Books]) -> (total: Int, mean: Int) {
        var total = 0
        for book in books {
            total += book.weight
        }
        let mean = total / books.count
        return (total, mean)
    }
    
    // Datos por ubicación
    func booksInPlace(_ place: Place) -> [Books] {
        booksModel.books.filter { $0.place == place }
    }
    
    func pagesAtPlace(_ place: Place) -> (total: Int, mean: Int) {
        let books = booksInPlace(place)
        if !books.isEmpty {
            var total = 0
            for book in books {
                total += book.pages
            }
            let mean = total / books.count
            return (total, mean)
        } else {
            return (0, 0)
        }
    }
    
    func priceAtPlace(_ place: Place) -> (total: Double, mean: Double) {
        let books = booksInPlace(place)
        if !books.isEmpty {
            var total = 0.0
            for book in books {
                total += book.price
            }
            let mean = total / Double(books.count)
            return (total, mean)
        } else {
            return (0, 0)
        }
    }
    
    func thicknessAtPlace(_ place: Place) -> (total: Double, mean: Double) {
        let books = booksInPlace(place)
        if !books.isEmpty {
            var total = 0.0
            for book in books {
                total += book.thickness
            }
            let mean = total / Double(books.count)
            return (total, mean)
        } else {
            return (0, 0)
        }
    }
    
    func weightAtPlace(_ place: Place) -> (total: Int, mean: Int) {
        let books = booksInPlace(place)
        if !books.isEmpty {
            var total = 0
            for book in books {
                total += book.weight
            }
            let mean = total / books.count
            return (total, mean)
        } else {
            return (0, 0)
        }
    }
    
    // Datos para la gráfica de barras (books)
    func booksToChart() -> [BarChartDataEntry] {
        var datas = [BarChartDataEntry]()
        var xValue = 0.0
        for place in Place.allCases {
            let data = BarChartDataEntry(x: xValue, y: Double(booksInPlace(place).count))
            datas.append(data)
            xValue += 1
        }
        return datas
    }
    
    func pagesToChart() -> [BarChartDataEntry] {
        var datas = [BarChartDataEntry]()
        var xValue = 0.0
        for place in Place.allCases {
            let data = BarChartDataEntry(x: xValue, y: Double(pagesAtPlace(place).total))
            datas.append(data)
            xValue += 1
        }
        return datas
    }
    
    func priceToChart() -> [BarChartDataEntry] {
        var datas = [BarChartDataEntry]()
        var xValue = 0.0
        for place in Place.allCases {
            let data = BarChartDataEntry(x: xValue, y: Double(priceAtPlace(place).total))
            datas.append(data)
            xValue += 1
        }
        return datas
    }
    
    func thicknessToChart() -> [BarChartDataEntry] {
        var datas = [BarChartDataEntry]()
        var xValue = 0.0
        for place in Place.allCases {
            let data = BarChartDataEntry(x: xValue, y: Double(thicknessAtPlace(place).total))
            datas.append(data)
            xValue += 1
        }
        return datas
    }
    
    func weightToChart() -> [BarChartDataEntry] {
        var datas = [BarChartDataEntry]()
        var xValue = 0.0
        for place in Place.allCases {
            let data = BarChartDataEntry(x: xValue, y: Double(weightAtPlace(place).total)/1000)
            datas.append(data)
            xValue += 1
        }
        return datas
    }
    
    // Datos para la gráfica pieChart (readingData)
    var totalRDPages: Int {
        var pages = 0
        for data in readingDataModel.readingDatas {
            pages += data.pages
        }
        return pages
    }
    
    func readBooksToChart(_ readingData: [ReadingData]) -> [PieChartDataEntry] {
        var datas = [PieChartDataEntry]()
        func booksPerYear(year: Year) -> Int {
            let books = readingData.filter { $0.finishedInYear == year }
            return books.count
        }
        for year in Year.allCases {
            let data = PieChartDataEntry(value: Double(booksPerYear(year: year)), label: String(year.rawValue))
            datas.append(data)
        }
        return datas
    }
    
    func readPagesToChart(_ readingData: [ReadingData]) -> [PieChartDataEntry] {
        var datas = [PieChartDataEntry]()
        func pagesPerYear(year: Year) -> Int {
            let books = readingData.filter { $0.finishedInYear == year }
            var pages = 0
            for book in books {
                pages += book.pages
            }
            return pages
        }
        for year in Year.allCases {
            let data = PieChartDataEntry(value: Double(pagesPerYear(year: year)), label: String(year.rawValue))
            datas.append(data)
        }
        return datas
    }
    
    func pagPerDayToChart(_ readingData: [ReadingData]) -> [PieChartDataEntry] {
        var datas = [PieChartDataEntry]()
        func meanValue(year: Year) -> Double {
            let books = readingData.filter { $0.finishedInYear == year }
            var sum = 0.0
            for book in books {
                sum += book.pagPerDay
            }
            let mean = sum / Double(books.count)
            return mean
        }
        for year in Year.allCases {
            let data = PieChartDataEntry(value: meanValue(year: year), label: String(year.rawValue))
            datas.append(data)
        }
        return datas
    }
    
    func readFormattToChart(_ readingData: [ReadingData]) -> [PieChartDataEntry] {
        var datas = [PieChartDataEntry]()
        func numFormatt(_ formatt: Formatt) -> Int {
            let books = readingData.filter { $0.formatt == formatt }
            return books.count
        }
        for formatt in Formatt.allCases {
            let data = PieChartDataEntry(value: Double(numFormatt(formatt)), label: formatt.rawValue)
            datas.append(data)
        }
        return datas
    }
    
    func ratingToChart(_ readingData: [ReadingData]) -> [PieChartDataEntry] {
        var datas = [PieChartDataEntry]()
        func numRating(_ rate: Rating) -> Int {
            let books = readingData.filter { $0.rating == rate }
            return books.count
        }
        for rate in Rating.allCases {
            let data = PieChartDataEntry(value: Double(numRating(rate)), label: "\(rate.rawValue) estrellas")
            datas.append(data)
        }
        return datas
    }
    
    func meanValuesToChart(_ readingData: [ReadingData]) -> ([ChartDataEntry], [ChartDataEntry]) {
        var datas1 = [ChartDataEntry]()
        var datas2 = [ChartDataEntry]()
        var sum: Double = 0
        for (index, book) in readingData.enumerated() {
            let x = Double(index + 1)
            let y1 = book.pagPerDay
            var y2 : Double {
                sum += book.pagPerDay
                let mean = sum / x
                return mean
            }
            let data1 = ChartDataEntry(x: x, y: y1)
            let data2 = ChartDataEntry(x: x, y: y2)
            datas1.append(data1)
            datas2.append(data2)
        }
        return (datas1, datas2)
    }
    
}



// MARK: - ReadingData type and structure

struct ReadingData: Codable, Identifiable {
    var id: Int
    var yearId: Int
    var bookTitle: String
    var startDate: String
    var finishDate: String
    var finishedInYear: Year
    var sessions: Int
    var duration: String
    var pages: Int
    var over50: Int
    var minPerPag: String
    var minPerDay: String
    var pagPerDay: Double
    var percentOver50: Double
    var formatt: Formatt
    var rating: Rating
    var synopsis: String
    var cover: String
}

enum Year: Int, Codable, CaseIterable {
    case year2019 = 2019
    case year2020 = 2020
    case year2021 = 2021
    case year2022 = 2022
}

enum Formatt: String, Codable, CaseIterable {
    case paper = "Papel"
    case kindle = "Kindle"
}

enum Rating: Int, Codable, CaseIterable {
    case oneStar = 1
    case twoStars = 2
    case threeStars = 3
    case fourStars = 4
    case fiveStars = 5
}

// MARK: - ReadingData model data

struct ReadingDataModel {
    
    var readingDatas: [ReadingData] {
        didSet {
            saveToJson()
            totalReadingDatas = readingDatas.count
        }
    }
    var totalReadingDatas: Int
    
    // Inicializador para cargar los datos
    init() {
        guard var url = Bundle.main.url(forResource: "READINGDATA", withExtension: "json") else {
            readingDatas = []
            totalReadingDatas = 0
            return
        }
        let documents = getDocumentsDirectory()
        let file = documents.appendingPathComponent("READINGDATA").appendingPathExtension("json")
        if FileManager.default.fileExists(atPath: file.path) {
            url = file
            print("Carga inicial desde archivo: \n" + file.absoluteString)
        } else { print("Carga inicial desde Bundle") }
        // do-try-catch para cargar los datos
        do {
            let jsonData = try Data(contentsOf: url) //datos cargados en memoria
            readingDatas = try JSONDecoder().decode([ReadingData].self, from: jsonData) //extraer los datos
            totalReadingDatas = readingDatas.count
        } catch {
            print("Error en la carga \(error)")
            readingDatas = []
            totalReadingDatas = 0
        }
    }
    
    func saveToJson() {
        // Get the url of json in document directory
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        let fileURL = documentPath.appendingPathComponent("READINGDATA.json")
        // Transform array into data and save it into file
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(readingDatas)
            try data.write(to: fileURL)
            print("Grabación correcta")
            print(fileURL.absoluteString) //para obtener la ruta al archivo
        } catch {
            print("Error en la grabación \(error)")
        }
    }
    
    mutating func deleteReadingData(indexPath: IndexPath) {
        let readingData = queryReadingData(indexPath: indexPath)
        readingDatas.removeAll(where: { $0.id == readingData.id })
    }
    
    // Número de localizaciones para el número de secciones
    var numSections: Int {
        Year.allCases.count
    }
    
    // Nombre de las secciones para tableView
    func sectionName(section: Int) -> String {
        let books = numBooksPerYear(section: section)
        return "\(Year.allCases.reversed()[section].rawValue) - \(books) libros"
    }
    
    // Número de libros por año para el número de celdas por sección
    func numBooksPerYear(section: Int) -> Int {
        let year = Year.allCases.reversed()[section]
        return readingDatas.filter { $0.finishedInYear == year }.count
    }
    
    // Recuperar datos para cada celda
    func queryReadingData(indexPath: IndexPath) -> ReadingData {
        let yearToSearch = Year.allCases.reversed()[indexPath.section]
        let dataArray = readingDatas.filter { $0.finishedInYear == yearToSearch }
        return dataArray.reversed()[indexPath.row]
    }
    
    // Recuperar la portada
    func getCoverImage(cover: String) -> UIImage {
        var coverToShow = UIImage()
        if let existingCover = UIImage(named: cover) {
            coverToShow = existingCover
        } else {
            let documents = getDocumentsDirectory()
            let file = documents.appendingPathComponent(cover).appendingPathExtension("jpg")
            if FileManager.default.fileExists(atPath: file.path) {
                do {
                    let coverData = try Data(contentsOf: file)
                    if let savedCover = UIImage(data: coverData) {
                        coverToShow = savedCover
                    }
                } catch {
                    print("Error al convertir la imagen: \(error)")
                }
            }
        }
        return coverToShow
    }
    
    // Función de búsqueda
    func searchReadingData(text: String, scope: Int) -> [ReadingData] {
        if scope == 0 {
            return readingDatas.filter { $0.bookTitle.lowercased().contains(text) }
        } else if scope == 1 {
            return readingDatas.filter { $0.formatt.rawValue.lowercased().contains(text) }
        } else if scope == 2 {
            return readingDatas.filter { $0.rating.rawValue == Int(text) }
        } else {
            fatalError()
        }
    }
    
    // Cálculo de los valores medios
    var meanMinPerPag: Double {
        var sum: Double = 0
        var mean: Double
        for data in readingDatas {
            sum += minPerPagInMinutes(data.minPerPag)
        }
        mean = sum / Double(readingDatas.count)
        return mean
    }
    var meanMinPerDay: Double {
        var sum: Double = 0
        var mean: Double
        for data in readingDatas {
            sum += minPerDayInHours(data.minPerDay)
        }
        mean = sum / Double(readingDatas.count)
        return mean
    }
    var meanPagPerDay: Double {
        var sum: Double = 0
        var mean: Double
        for data in readingDatas {
            sum += data.pagPerDay
        }
        mean = sum / Double(readingDatas.count)
        return mean
    }
    var meanOver50: Double {
        var sum: Double = 0
        var mean: Double
        for data in readingDatas {
            sum += data.percentOver50
        }
        mean = sum / Double(readingDatas.count)
        return mean
    }
    
    func compareExistingData(formatt: Formatt, text: String) -> (num: Int, dataSet: Set<String>) {
        var dataTotalArray = [String]()
        if formatt == .kindle {
            let foundEBookArray = eBooksModel.eBooks.filter { $0.bookTitle.lowercased().contains(text.lowercased()) }
            for ebook in foundEBookArray {
                dataTotalArray.append(ebook.bookTitle)
            }
        } else {
            let foundBookArray = booksModel.books.filter { $0.bookTitle.lowercased().contains(text.lowercased()) }
            for book in foundBookArray {
                dataTotalArray.append(book.bookTitle)
            }
        }
        let setWithData = Set(dataTotalArray)
        return (setWithData.count, setWithData)
    }
    
}



// MARK: - eBooks data type and structure

struct EBooks: Codable {
    var id: Int
    var author: String
    var bookTitle: String
    var originalTitle: String
    var year: Int
    var pages: Int
    var status: ReadingStatus
}

// MARK: - EBook model data

struct EBooksModel {
    var eBooks: [EBooks] {
        didSet {
            saveToJson()
            totalEBooks = eBooks.count
        }
    }
    var totalEBooks: Int
    
    init() {
        // Este código comprueba que exista un archivo EBOOKS en el directorio principal y luego busca la ruta donde se guardan los archivos de la app. En esa ruta busca un archivo EBOOKS, y si ya existe, lo asigna a la variable url que es de la que luego se hará el decode; si no existe EBOOKS en los archivos, usa el EBOOKS del directorio principal.
        guard var url = Bundle.main.url(forResource: "EBOOKS", withExtension: "json") else {
            eBooks = []
            totalEBooks = 0
            return
        }
        let documents = getDocumentsDirectory()
        let fileURL = documents.appendingPathComponent("EBOOKS").appendingPathExtension("json")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            url = fileURL
            print("Carga inicial desde archivo: \n" + fileURL.absoluteString)
        } else { print("Carga inicial desde Bundle") }
        
        do {
            let jsonData = try Data(contentsOf: url)
            eBooks = try JSONDecoder().decode([EBooks].self, from: jsonData)
            totalEBooks = eBooks.count
        } catch {
            print("Error en la carga \(error)")
            eBooks = []
            totalEBooks = 0
        }
        
        /*// Prueba para Decode más sencillo según otro vídeo: Funciona. Lo que hace es leer siempre directamente el archivo original EBOOKS del directorio principal, sin comprobar si existe otro previo.
        guard let url = Bundle.main.url(forResource: "EBOOKS", withExtension: "json") else {
            eBooks = []
            totalEBooks = 0
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            eBooks = try decoder.decode([EBooks].self, from: data)
            totalEBooks = eBooks.count
        } catch {
            print("Error en la carga de ebooks: \(error)")
            eBooks = []
            totalEBooks = 0
        }*/
    }
    
    func queryEBook(indexPath: IndexPath) -> EBooks {
        eBooks[indexPath.row]
    }
    
    func searchEBook(text: String, scope: Int) -> [EBooks] {
        if scope == 0 {
            return eBooks.filter { $0.bookTitle.lowercased().contains(text) }
        } else if scope == 1 {
            return eBooks.filter { $0.author.lowercased().contains(text) }
        } else if scope == 2 {
            return eBooks.filter { $0.status.rawValue.lowercased().contains(text) }
        } else {
            fatalError()
        }
    }
    
    func saveToJson() {
        // Get the url of json in document directory
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        let fileURL = documentPath.appendingPathComponent("EBOOKS.json")
        // Transform array into data and save it into file
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(eBooks)
            try data.write(to: fileURL)
            print("Grabación correcta")
            print(fileURL.absoluteString) //para obtener la ruta al archivo
        } catch {
            print("Error en la grabación \(error)")
        }
    }
    
    mutating func deleteEBook(indexPath: IndexPath) {
        let eBook = queryEBook(indexPath: indexPath)
        eBooks.removeAll(where: { $0.id == eBook.id })
    }
    
    mutating func updateEBook(eBook: EBooks) {
        guard let index = eBooks.firstIndex(where: { $0.id == eBook.id }) else { return }
        eBooks[index] = eBook
    }
    
    // Devuelve la imagen según el estado
    func imageStatus(_ eBook: EBooks) -> UIImage {
        switch eBook.status {
        case .notRead:
            return UIImage(systemName: "bookmark.slash")!.withTintColor(.systemRed).withRenderingMode(.alwaysOriginal)
        case .read:
            return UIImage(systemName: "book")!.withTintColor(.systemGreen).withRenderingMode(.alwaysOriginal)
        case .registered:
            return UIImage(systemName: "paperclip")!
        case .consulting:
            return UIImage(systemName: "text.book.closed")!.withTintColor(.systemBrown).withRenderingMode(.alwaysOriginal)
        case .noStatus:
            return UIImage(systemName: "questionmark.app")!.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        }
    }
    
    func compareExistingAuthors(text: String) -> (num: Int, authorSet: Set<String>) {
        var authorTotalArray = [String]()
        let foundEBookArray = eBooks.filter { $0.author.lowercased().contains(text.lowercased()) }
        for ebook in foundEBookArray {
            authorTotalArray.append(ebook.author)
        }
        let setWithAuthors = Set(authorTotalArray)
        return (setWithAuthors.count, setWithAuthors)
    }
        
}



// MARK: - Number formatters

let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale.init(identifier: "fr_FR")
    formatter.numberStyle = .currency
    return formatter
}()

let measureFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.decimalSeparator = ","
    formatter.groupingSeparator = "."
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 1
    return formatter
}()

let noDecimalFormatter: NumberFormatter = {
   let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.groupingSeparator = "."
    return formatter
}()



// MARK: - Funciones varias

// Funciones para pasar datos de tiempo de tipo String a Double
func minPerPagInMinutes(_ value: String) -> Double {
    var array = [Double]()
    for char in value {
        if let num = Double(String(char)) {
            array.append(num)
        }
    }
    let min = array[0]
    var seg: Double {
        if array.count == 2 {
            return array[1]
        } else if array.count == 3 {
            return array[1]*10 + array[2]
        } else { return 0 }
    }
    let total = min + (seg / 60)
    return total
}
func minPerDayInHours(_ value: String) -> Double {
    var array = [Double]()
    for char in value {
        if let num = Double(String(char)) {
            array.append(num)
        }
    }
    let hour = array[0]
    var min: Double {
        if array.count == 2 {
            return array[1]
        } else if array.count == 3 {
            return array[1]*10 + array[2]
        } else { return 0 }
    }
    let total = hour + (min / 60)
    return total
}

// Funciones para pasar los datos de tiempo de tipo Double a String

func minPerPagDoubleToString(_ value: Double) -> String {
    let float = value.truncatingRemainder(dividingBy: 1)
    let min = Int(value - float)
    let seg = Int(round(float * 60))
    return "\(min)min \(seg)s"
}
func minPerDayDoubleToString(_ value: Double) -> String {
    let float = value.truncatingRemainder(dividingBy: 1)
    let hour = Int(value - float)
    let min = Int(round(float * 60))
    return "\(hour)h \(min)min"
}

// Funciones de comparación de cada valor con la media
func compareWithMean(value: Double, mean: Double) -> (color: UIColor, image: String) {
    if value >= mean {
        return (UIColor(red: 104/255, green: 157/255, blue: 55/255, alpha: 1), "arrow.up")
    } else {
        return (UIColor(red: 227/255, green: 36/255, blue: 1/255, alpha: 1), "arrow.down")
    }
}

// Función para crear un datePicker para fechas
func createDatePicker(target: Any?, _ selector: Selector) -> UIDatePicker {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.locale = Locale(identifier: "es_ES")
    datePicker.addTarget(target, action: selector, for: UIControl.Event.valueChanged)
    datePicker.frame.size = CGSize(width: 0, height: 300)
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.maximumDate = Date()
    return datePicker
}

// Función de formato para las fechas de datePicker, devuelve string
func formatDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    formatter.locale = Locale(identifier: "fr_FR")
    let dateString = formatter.string(from: date)
    return dateString
}

// Función para crear ruta y luego guardar los datos
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

