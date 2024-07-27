--混沌圣堂的警哨
local s,id,o=GetID()
Duel.LoadScript("c33201450.lua")
function s.initial_effect(c)
	VHisc_HDST.fth(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e1:SetCondition(s.con)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
end
s.VHisc_hdst=true

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c,tp) return c:IsControler(1-tp) end,1,nil,tp)
end
function s.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,s.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=Duel.GetFirstTarget()
	e:SetLabel(0)
	if VHisc_HDST.nck(tc) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) then
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,0,tp,1)
	end
end
function s.filter(c)
	return VHisc_HDST.nck(c) and c:IsAbleToHand()
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackPos() then
		Duel.Hint(24,0,aux.Stringid(id,0))
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		if e:GetLabel()==1 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,2,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
