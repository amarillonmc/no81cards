--唤祐重器 大盂鼎
local s,id,o=GetID()
Duel.LoadScript("c33201370.lua")
Duel.LoadScript("c33201350.lua")
function s.initial_effect(c)
	VHisc_HYZQ.rlef(c,id,0x10000)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.VHisc_HYZQ=true
s.VHisc_CNTreasure=true

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(VHisc_HYZQ.rlft,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) and VHisc_HYZQ.mck(tp,id) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,VHisc_HYZQ.rlft,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local ct=Duel.SendtoGrave(g,REASON_RELEASE)
	VHisc_HYZQ.mop(e,tp,m)
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end

--Release effect
function s.filter(c)
	return c.VHisc_HYZQ and not c:IsCode(id) and c:IsAbleToHand()
end
function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.GetDecktopGroup(tp,1):GetFirst()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,dc)
	if VHisc_CNTdb.nck(dc) then
		Duel.ShuffleHand(tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(s.val)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.val(e,re,dam,r,rp,rc)
	dam=dam-1000
	return dam>0 and dam or 0
end