--幽冥骑士 格里克
local s,id,o=GetID()
function s.initial_effect(c)
	--Xyz Summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,8,3)
	--Attach Material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.atcon)
	e1:SetTarget(s.attg)
	e1:SetOperation(s.atop)
	c:RegisterEffect(e1)
	--Compare ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(s.compcost)
	e2:SetTarget(s.comptg)
	e2:SetOperation(s.compop)
	c:RegisterEffect(e2)
	--Revive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+o*2)
	e3:SetCondition(s.revcon)
	e3:SetTarget(s.revtg)
	e3:SetOperation(s.revop)
	c:RegisterEffect(e3)
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.atchfilter(c)
	return c:IsSetCard(0xd70)
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(s.atchfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.atchfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function s.compcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if tc:IsSetCard(0xd70) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SendtoGrave(tc,REASON_COST)
end
function s.compfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetTextAttack()~=-2 and not c:IsForbidden()
end
function s.comptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.compfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_DECK)
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
end
function s.compop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.compfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(s.compfilter,1-tp,LOCATION_DECK,0,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local sg2=g2:Select(1-tp,1,1,nil)
	local tc1=sg1:GetFirst()
	local tc2=sg2:GetFirst()
	Duel.ConfirmCards(1-tp,tc1)
	Duel.ConfirmCards(tp,tc2)
	local atk1=tc1:GetTextAttack()
	local atk2=tc2:GetTextAttack()
	if atk1>atk2 then
		s.winop(e,tp,tc1)
		s.loseop(e,1-tp,tc2)
	elseif atk2>atk1 then
		s.winop(e,1-tp,tc2)
		s.loseop(e,tp,tc1)
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function s.winop(e,p,tc)
	if tc:IsCanBeSpecialSummoned(e,0,p,false,false) and Duel.GetLocationCount(p,LOCATION_MZONE)>0 then
		if Duel.SpecialSummonStep(tc,0,p,p,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
function s.loseop(e,p,tc)
	local dam=tc:GetTextAttack()/2
	if Duel.Destroy(tc,REASON_EFFECT)~=0 and dam>0 then
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
function s.revcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:GetPreviousOverlayCountOnField()>0
end
function s.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.revop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,4))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
