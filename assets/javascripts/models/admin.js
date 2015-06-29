function AdminViewModel() {
  var self = this;
  self.numbers = ko.observableArray([]);

  self.addSeat = function () {
    self.seats.push("");
  };
  self.removeNumber = function (number) {
    self.numbers.remove(number);
  };
  self.save = function () {
    $.post("/api/numbers", {numbers: self.numbers() }, self.numbers)
  };

  $.getJSON("/api/numbers", function (numbers) {
    self.numbers(numbers);
    console.log(self.numbers());
  });
}
