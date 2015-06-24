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
    console.log(ko.toJSON({ numbers: self.numbers }));
    $.ajax("/api/numbers", {
      data: ko.toJSON({ numbers: self.numbers }),
      dataType: 'json',
      type: "post",
      contentType: "application/json",
      success: function (result) {
        console.log(result);
      }
    });
  };

  $.getJSON("/api/numbers", function (numbers) {
    self.numbers(numbers);
    console.log(self.numbers());
  });
}
