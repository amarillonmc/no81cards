--破碎世界 纷争
function c6160605.initial_effect(c)
	--to hand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160605,0))  
	e1:SetCategory(CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_ACTIONS) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)   
	e1:SetCountLimit(1,81055000)  
	e1:SetTarget(c81055000.thtg1)  
	e1:SetOperation(c81055000.thop1)  
	c:RegisterEffect(e1)
end
