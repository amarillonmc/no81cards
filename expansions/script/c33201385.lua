--墨染山河 百花图卷
local s,id,o=GetID()
Duel.LoadScript("c33201381.lua")
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	VHisc_MRSH.mtoken(c,id,id-40)   
	VHisc_MRSH.dsp(c,id)   
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,id+20000)
	e2:SetTarget(s.ptg)
	e2:SetOperation(s.pop)
	c:RegisterEffect(e2) 
end
s.VHisc_MRSH=true
s.VHisc_CNTreasure=true
	
function s.thfilter(c)
	return c.VHisc_MRSH and not c:IsCode(id) and c:IsAbleToHand() 
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if thg:GetCount()>0 and Duel.SendtoHand(thg,nil,REASON_EFFECT)~=0 and thg:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,thg)
			Duel.ShuffleHand(tp)
			Duel.ShuffleDeck(tp)
		end
	end
end

function s.top(c)
	Duel.Hint(HINT_CARD,c:GetPreviousControler(),id-40)
	local tp=c:GetPreviousControler()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(800)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
