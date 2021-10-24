--歌蕾蒂娅·碎漩狂舞
function c29010018.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--code
	aux.EnableChangeCode(c,29010017,LOCATION_MZONE+LOCATION_GRAVE)
	--CopyEffect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(c29010018.efop)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29010018,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c29010018.mvcon)
	e3:SetTarget(c29010018.mvtg)
	e3:SetOperation(c29010018.mvop)
	c:RegisterEffect(e3)
end
function c29010018.effilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x77af)
end
function c29010018.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetHandler():GetOverlayGroup()
	local wg=g:Filter(c29010018.effilter,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:GetFlagEffect(code)==0 then
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)
		end
		wbc=wg:GetNext()
	end
end
function c29010018.mvfilter(c)
	return not c:IsLocation(LOCATION_FZONE)
end
function c29010018.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and mg:GetCount()>0 and mg:IsExists(Card.IsCode,1,nil,29010017)
end
function c29010018.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c29010018.mvfilter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>1 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c29010018.mvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.GetMatchingGroup(c29010018.mvfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	local sc=sg:GetFirst()
	local seq1=sc:GetSequence()
	if seq1==5 then seq1=1 end
	if seq1==6 then seq1=3 end
	g:RemoveCard(sc)
	local dg=Group.CreateGroup()
	while g:GetCount()>0 do
		local tg=g:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		local seq2=tc:GetSequence()
		local loc=tc:GetLocation()
		if tc:IsLocation(LOCATION_PZONE) then
			dg:AddCard(tc)
		elseif seq2>4 then
			if seq2==5 then seq2=1 end
			if seq2==6 then seq2=3 end
			if Duel.CheckLocation(1-tp,LOCATION_MZONE,seq2) then Duel.MoveSequence(tc,seq2)
			else dg:AddCard(tc) end
		elseif seq1>seq2 then
			if Duel.CheckLocation(1-tp,loc,seq2+1) then Duel.MoveSequence(tc,seq2+1)
			else dg:AddCard(tc) end
		elseif seq1<seq2 then
			if Duel.CheckLocation(1-tp,loc,seq2-1) then Duel.MoveSequence(tc,seq2-1)
			else dg:AddCard(tc) end
		else
			dg:AddCard(tc)
		end
		g:RemoveCard(tc)
	end
	if dg:GetCount()>0 then
		Duel.SendtoGrave(dg,REASON_EFFECT)
	end
end
