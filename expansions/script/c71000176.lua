--七仟陌的时钟
function c71000176.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xe73),aux.NonTuner(Card.IsSetCard,0xe73),1)
	c:EnableReviveLimit()
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71000176,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,71000176)
	e1:SetTarget(c71000176.tg)
	e1:SetOperation(c71000176.op)
	c:RegisterEffect(e1)
	--2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c71000176.target)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	c:RegisterEffect(e4)
	--3
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(71000176,0))
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetCountLimit(1,71000176)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCondition(c71000176.spcon)
	c:RegisterEffect(e12)
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_FIELD)
	e41:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e41:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e41:SetRange(LOCATION_MZONE)
	e41:SetAbsoluteRange(tp,1,0)
	e41:SetTarget(c71000176.splimit)
	c:RegisterEffect(e41)
end
function c71000176.splimit(e,c)
	return not c:IsRace(RACE_SPELLCASTER)

end
--1

function c71000176.f(c)
	return  c:IsAbleToHand() and c:IsSetCard(0xe73)
end 
function c71000176.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71000176.f,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71000176.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71000176.f,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0  then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--2
function c71000176.target(e,c)
	return c:IsCode(71000100) and c:IsFaceup()
end

--3
function c71000176.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe73) and c:IsType(TYPE_MONSTER)
end
function c71000176.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71000176.cfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end