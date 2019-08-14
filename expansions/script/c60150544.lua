--幻想曲的破灭之骸
function c60150544.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xab20),3)
	c:EnableReviveLimit()
	--summon
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e21:SetCode(EVENT_SPSUMMON_SUCCESS)
	e21:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e21:SetCondition(c60150544.descon)
	e21:SetTarget(c60150544.destg)
	e21:SetOperation(c60150544.desop)
	c:RegisterEffect(e21)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c60150544.tgtg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c60150544.efilter)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCountLimit(1,60150544)
	e3:SetTarget(c60150544.destg2)
	e3:SetOperation(c60150544.desop2)
	c:RegisterEffect(e3)
end
function c60150544.matfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c60150544.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial():Filter(c60150544.matfilter,nil)
	return c:IsSummonType(SUMMON_TYPE_LINK) and g:GetCount()>0
end
function c60150544.filter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsType(TYPE_XYZ) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150544.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c60150544.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c60150544.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60150544.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60150544.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60150544.tgtg(e,c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT) and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c60150544.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c60150544.dfilter(c)
	return c:IsDestructable()
end
function c60150544.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetLinkedGroup()
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Group.Sub(g2,g)
	if chk==0 then return g2:FilterCount(c60150544.dfilter,e:GetHandler())>0 end
	local g3=g2:Filter(c60150544.dfilter,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g3,g3:GetCount(),0,0)
	if Duel.GetTurnPlayer()==tp then
		Duel.SetChainLimit(c60150544.chlimit)
	end
end
function c60150544.chlimit(e,ep,tp)
	return tp==ep
end
function c60150544.desop2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=e:GetHandler():GetLinkedGroup()
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Group.Sub(g2,g)
	local g3=g2:Filter(c60150544.dfilter,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g3:Select(tp,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		if Duel.Destroy(sg,REASON_EFFECT)~=0 then
			local tc=sg:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(0,1)
			e1:SetValue(c60150544.aclimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c60150544.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
