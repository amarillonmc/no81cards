--无名的白银姬
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.sumsuc)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
	--dis
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+100)
	e4:SetCondition(s.discon)
	e4:SetTarget(s.distg)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4)
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
function s.cfilter(c)
	return c:GetType()==TYPE_TRAP  and c:IsAbleToGraveAsCost()
end
function s.fselect(g,tp,mc)
	if mc:IsLocation(LOCATION_GRAVE) then return Duel.GetMZoneCount(tp,g,tp)>0 end
	return Duel.GetLocationCountFromEx(tp,tp,g,mc)>0
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(s.fselect,2,2,tp,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,s.fselect,true,2,2,tp,c)
	if not sg then return false end
	sg:KeepAlive()
	e:SetLabelObject(sg)
	return true
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function s.setfilter(c,e,tp)
	local b1=c:IsSSetable()
	local te,eg,ep,ev,re,r,rp=c:CheckActivateEffect(true,true,true)
	local cost=nil
	if te and te:GetCost() then cost=te:GetCost() end
	local condition=nil
	if te and te:GetCondition() then condition=te:GetCondition() end
	local tg=nil
	if te and te:GetTarget() then tg=te:GetTarget() end
	local b2=c:CheckActivateEffect(true,true,false)~=nil 
		and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and te:CheckCountLimit(tp)==true
		and (not condition or condition(e,tp,eg,ep,ev,re,r,rp)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0))
	return c:IsFaceupEx() and c:GetType()==TYPE_TRAP and (b1 or b2)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) end
	local sg=Group.CreateGroup()
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,3,nil,e,tp)
	sg:Merge(g)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	Duel.ClearTargetCard()
	Duel.ClearOperationInfo(0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sc=tg:Select(tp,1,1,nil):GetFirst()
		if sc then
			tg:RemoveCard(sc)
			local te=sc:GetActivateEffect()
			local cte,ceg,cep,cev,cre,cr,crp=sc:CheckActivateEffect(true,true,true)
			local cost=nil
			if cte and cte:GetCost() then cost=cte:GetCost() end
			local condition=nil
			if cte and cte:GetCondition() then condition=cte:GetCondition() end
			local target=nil
			if cte and cte:GetTarget() then target=cte:GetTarget() end
			local b1=sc:CheckActivateEffect(true,true,false)~=nil 
				and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and te:CheckCountLimit(tp)==true
				and (not condition or condition(e,tp,eg,ep,ev,re,r,rp)) and (not target or target(e,tp,eg,ep,ev,re,r,rp,0))
			local b2=sc:IsSSetable()
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=1150
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=1153
				opval[off-1]=2
				off=off+1
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			local sel=opval[op]
			if sel==1 then
				Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local bc=Duel.GetOperatedGroup():GetFirst()
				te:UseCountLimit(tp,1,true)
				sc:CreateEffectRelation(te)
				Duel.RaiseEvent(sc,EVENT_CHAINING,cte,0,tp,tp,Duel.GetCurrentChain())
				local tep=sc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				local target=te:GetTarget()
				if target then target(e,tp,eg,ep,ev,re,r,rp,1) end
				local ag=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				for ac in aux.Next(ag) do
					--Duel.Hint(HINT_CARD,0,ac:GetOriginalCode())
					ac:CreateEffectRelation(te)
				end
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
				sc:ReleaseEffectRelation(te)
				for ac in aux.Next(ag) do
					ac:ReleaseEffectRelation(te)
				end
				if not sc:IsType(TYPE_CONTINUOUS) then
					Duel.SendtoGrave(sc,REASON_RULE)
				end
			else
				if sc and Duel.SSet(tp,sc)~=0 then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e1)
				end
			end
			Duel.BreakEffect()
			Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE) --and re:GetActivateLocation()==LOCATION_SZONE
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end