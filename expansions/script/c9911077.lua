--吸血鬼魔血 源血护身
function c9911077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9911077.target)
	e1:SetOperation(c9911077.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c9911077.actcon)
	c:RegisterEffect(e2)
end
function c9911077.actcon(e)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c9911077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,9911077,0x8e,TYPES_NORMAL_TRAP_MONSTER,1000,1000,6,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911077.checkfilter(c)
	return c:IsCode(9911056) and c:IsFaceup()
end
function c9911077.xyzfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsXyzSummonable(nil)
end
function c9911077.xmfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function c9911077.xfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function c9911077.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,9911077,0x8e,TYPES_NORMAL_TRAP_MONSTER,1000,1000,6,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c9911077.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		local g1=Duel.GetMatchingGroup(c9911077.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		local b2=Duel.IsExistingMatchingCard(c9911077.xmfilter,tp,0,LOCATION_ONFIELD,1,nil,e)
			and Duel.IsExistingMatchingCard(c9911077.xfilter,tp,LOCATION_MZONE,0,1,nil,e)
		local off=1
		local ops={}
		local opval={}
		if #g1>0 then
			ops[off]=aux.Stringid(9911077,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(9911077,1)
			opval[off-1]=2
			off=off+1
		end
		ops[off]=aux.Stringid(9911077,2)
		opval[off-1]=3
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		if sel==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g1:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,sg:GetFirst(),nil)
		elseif sel==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g2=Duel.SelectMatchingCard(tp,c9911077.xmfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e)
			if #g2==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g3=Duel.SelectMatchingCard(tp,c9911077.xfilter,tp,LOCATION_MZONE,0,1,1,nil,e)
			if #g3==0 then return end
			Duel.HintSelection(g2)
			local tc=g2:GetFirst()
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			tc:CancelToGrave()
			Duel.Overlay(g3:GetFirst(),g2)
		end
	end
end
