--机艺核芯
local m=20000421
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000400") end) then require("script/c20000400") end
function cm.initial_effect(c)
--active
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
--attack redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(cm.con2)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
--return hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
--e1
function cm.opf1(c,e,tp)
	return c:IsSetCard(0xfd4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.opf1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local sc=Duel.SelectMatchingCard(tp,cm.opf1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e2
function cm.con2(e)
	local tp=e:GetOwnerPlayer()
	return Duel.IsExistingMatchingCard(fu_hd.Infinity,tp,LOCATION_MZONE,0,1,nil)
end
--e5
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and not Duel.GetTurnPlayer()==tp end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsOnField() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end