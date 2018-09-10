import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    var dreams = [String]()
    @objc dynamic var selectedIndexes = IndexSet()

    @IBOutlet weak var table: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dreams = ["Hit the gym", "Run daily", "Become a millionaire", "Become a better programmer", "Achieve your dreams"]
        table.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dreams.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let dream = table.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        dream.textField?.stringValue = dreams[row]
        
        return dream
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return dreams[row]
    }
    
    func addNewDream() {
        let last = dreams.count
        dreams.append("Double Click or Press Enter to Add Item")
        table.insertRows(at: IndexSet(integer: last), withAnimation: .effectGap)
        table.scrollRowToVisible(last)
        table.selectRowIndexes([last], byExtendingSelection: false)
        
        saveDreams()
    }
    
    func removeDream() {
        guard let selectedRow = selectedIndexes.first else { return }
        dreams.remove(at: selectedRow)
        table.removeRows(at: IndexSet(integer: selectedRow), withAnimation: .effectFade)
        
        saveDreams()
    }

    override func controlTextDidChange(_ obj: Notification) {
        saveDreams()
    }

    override var representedObject: Any? {
        didSet {

        }
    }

    @IBAction func addTableRow(_ sender: Any) {
        addNewDream()
    }
    
    @IBAction func removeTableRow(_ sender: Any) {
        removeDream()
    }
    
    
    func saveDreams() {
//        defaults[.dreams] = dreams
    }
}

