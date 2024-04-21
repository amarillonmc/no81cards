--焕然之氤氲 阿黛尔
function c9911427.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--effect draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	e1:SetCondition(c9911427.drcon)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9911427.imtg)
	e2:SetOperation(c9911427.imop)
	c:RegisterEffect(e2)
end
function c9911427.drcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c9911427.matcheck(e,c)
	e:SetLabel(c:GetMaterial())
end
function c9911427.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=c:GetMaterialCount() end
	e:SetLabel(c:GetMaterialCount())
end
function c9911427.cfilter(c,typ)
	return c:IsFaceup() and c:IsType(typ)
end
function c9911427.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.SortDecktop(tp,tp,ct)
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local tg=Duel.GetMatchingGroup(c9911427.cfilter,tp,LOCATION_ONFIELD,0,sg,tc:GetType()&0x7)
		if #tg>0 then
			tg:AddCard(tc)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911427,0))
			local sc=tg:Select(tp,1,1,nil):GetFirst()
			if not g:IsContains(sc) then sg:AddCard(sc) end
		end
	end
	if #sg==0 then return end
	Duel.HintSelection(sg)
	for nc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c9911427.efilter)
		e1:SetOwnerPlayer(tp)
		nc:RegisterEffect(e1)
	end
end
function c9911427.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
