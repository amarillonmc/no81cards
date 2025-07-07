--墨染山河 莲塘乳鸭图
local s,id,o=GetID()
Duel.LoadScript("c33201381.lua")
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	VHisc_MRSH.sptoken(c,id,id-40)   
	VHisc_MRSH.dsp(c,id)   
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,id+20000)
	e2:SetTarget(s.ptg)
	e2:SetOperation(s.pop)
	c:RegisterEffect(e2) 
end
s.VHisc_MRSH=true
s.VHisc_CNTreasure=true
	

function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 and Duel.Recover(tp,1500,REASON_EFFECT) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(aux.indoval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end


function s.thfilter(c)
	return c.VHisc_MRSH and c:IsAbleToHand()
end
function s.top(c)
	Duel.Hint(HINT_CARD,c:GetPreviousControler(),id-40)
	local tp=c:GetPreviousControler()
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if thg:GetCount()>0 and Duel.SendtoHand(thg,nil,REASON_EFFECT)~=0 and thg:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,thg)
			Duel.ShuffleHand(tp)
			Duel.ShuffleDeck(tp)
		end
	end
end