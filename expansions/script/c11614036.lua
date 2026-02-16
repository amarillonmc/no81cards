--雪域生灵 白狐
local s,id,o=GetID()
function s.initial_effect(c)
	--Link Summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.mfilter,2)
	--Effect 1: Opponent SS, then Self SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	--Effect 2: Declare count, destroy, apply
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end
function s.mfilter(c)
	return c:IsSetCard(0x5226)
end
function s.oppspfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
end
function s.myspfilter(c,e,tp)
	return c:IsSetCard(0x5226) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.myspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(1-tp,s.oppspfilter,tp,0,LOCATION_DECK,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK) then
			--Negate effects
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
			--Cannot activate
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.myspfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

--Effect 2
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local ac=Duel.AnnounceNumber(tp,0,1,2,3,4,5)
	e:SetLabel(ac)
	--Set info for potential categories, though not guaranteed
	if ac>=1 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0) end
	if ac>=3 then 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) 
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ac*300)
	end
	if ac==5 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) end
end
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ac=e:GetLabel()
	
	if ac==0 then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		s.apply_resolution(e,tp,tc,ac)
	else
		--Delayed resolution
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(s.countop)
		e1:SetLabel(ac,ac)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.countop(e,tp,eg,ep,ev,re,r,rp)
	local cur,orig=e:GetLabel()
	local tc=e:GetLabelObject()
	cur=cur-1
	e:SetLabel(cur,orig)
	if cur==0 then
		s.apply_resolution(e,tp,tc,orig)
		e:Reset()
	end
end
function s.apply_resolution(e,tp,tc,ac)
	if tc and tc:GetFlagEffect(id)>0 and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local destroyed_tc=og:GetFirst()
		
		if ac>=1 and destroyed_tc:IsAbleToHand(tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.SendtoHand(destroyed_tc,tp,REASON_EFFECT)
		end
	end
	if ac>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.myspfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.myspfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if ac>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.Recover(tp,ac*300,REASON_EFFECT)
	end
	
	if ac==5 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end
	end
end
