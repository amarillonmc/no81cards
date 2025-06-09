--旅游
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.XyzLevelFreeCondition(s.filter,nil,2,2))
	e0:SetTarget(s.XyzLevelFreeTarget(s.filter,nil,2,2))
	e0:SetOperation(Auxiliary.XyzLevelFreeOperation(s.filter,nil,2,2))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	
	--cannot direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_DESTROY)
	--e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.SpiritReturnTargetForced)
	e1:SetOperation(s.SpiritReturnOperation)
	c:RegisterEffect(e1)
	--remove
	local ed1=Effect.CreateEffect(c)
	ed1:SetDescription(aux.Stringid(id,1))
	ed1:SetCategory(CATEGORY_REMOVE)
	ed1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ed1:SetCode(EVENT_SPSUMMON_SUCCESS)
	ed1:SetRange(LOCATION_MZONE)
	ed1:SetTarget(s.destg)
	ed1:SetOperation(s.desop)
	c:RegisterEffect(ed1)
	local ed2=Effect.CreateEffect(c)
	ed2:SetDescription(aux.Stringid(id,1))
	ed2:SetCategory(CATEGORY_REMOVE)
	ed2:SetType(EFFECT_TYPE_IGNITION)
	ed2:SetRange(LOCATION_MZONE)
	ed2:SetCost(s.cost)
	ed2:SetTarget(s.destg)
	ed2:SetOperation(s.desop)
	c:RegisterEffect(ed2)
	
	--不能当召唤用素材--
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCode(EFFECT_UNRELEASABLE_SUM)
	e21:SetValue(1)
	c:RegisterEffect(e21)
	local e12=e21:Clone()
	e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e12)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e13:SetValue(1)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e14:SetValue(1)
	c:RegisterEffect(e14)
	local e15=e14:Clone()
	e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e15)
	local e16=e14:Clone()
	e16:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e16)
	--做超量素材时送去墓地
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_ADJUST)
	e4:SetCountLimit(13,id)
	e4:SetOperation(s.rmop)
	Duel.RegisterEffect(e4,0)
	--maintain
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e17:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e17:SetCode(EVENT_PHASE+PHASE_END)
	e17:SetRange(LOCATION_MZONE)
	e17:SetCountLimit(1)
	e17:SetCondition(s.mtcon)
	e17:SetOperation(s.mtop)
	c:RegisterEffect(e17)

end
function s.ndsfilter(c)
	return c:IsFaceup() and c:IsCode(5012613) and c:IsCode(5012625)
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.ndsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsAbleToExtra() or c:IsExtraDeckMonster()) then return end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
end
function s.SpiritReturnTargetForced(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.SpiritReturnOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function s.filter(c)
	return c.MoJin and not c:IsSummonableCard()
end
function s.XyzLevelFreeFilter(c,xyzc,f)
	return (not (c:IsOnField()or c:IsLocation(LOCATION_REMOVED)) or c:IsFaceup()) and c:IsCanBeXyzMaterial(xyzc) and (not f or f(c,xyzc))
end
function s.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function s.XyzLevelFreeCondition(f,gf,minct,maxct)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(s.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(s.XyzLevelFreeFilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function s.XyzLevelFreeTarget(f,gf,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(s.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(s.XyzLevelFreeFilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,Auxiliary.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function s.rmcon(e)
	local c=e:GetHandler()
	return true --c:IsAbleToGrave()
end
function s.rmop(e)
	local g=Duel.GetOverlayGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	local tgg=g:Filter(Card.IsCode,nil,id)
	if tgg and #tgg>0 then

		Duel.SendtoGrave(tgg,REASON_EFFECT)
	end
end
function s.refilter(c)
	return c:IsAbleToRemove()
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.refilter,tp,0xff,0xff,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,nil,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	--
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(0,id+1,0,0,1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_ADJUST)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetLabel(ac)
	e4:SetCondition(s.recon)
	e4:SetOperation(s.reop)
	Duel.RegisterEffect(e4,tp)

end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject():IsExists(s.retfilter,1,nil,e:GetLabel()) then
		e:GetLabelObject():DeleteGroup()
		e:Reset()
		return false
	end
	return true
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,id+1)
	local fid=e:GetLabel()
	local g=e:GetLabelObject():Filter(s.retfilter,nil,fid)
	if #g<=0 then return end
	Duel.Hint(HINT_CARD,0,id)
	for p in aux.TurnPlayers() do
		local tg=g:Filter(Card.IsPreviousControler,nil,p)
		local mt=Duel.GetLocationCount(p,LOCATION_MZONE)
		local st=Duel.GetLocationCount(p,LOCATION_SZONE)
		local mg=tg:Filter(Card.IsType,nil,TYPE_MONSTER)
		local sg=tg:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
		while #mg>0 and mt>0 do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOFIELD)
			local gg=mg:Select(p,1,1,nil)
			Duel.ReturnToField(gg:GetFirst())
			mg:Sub(gg)
		end
		while #sg>0 and st>0 do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOFIELD)
			local gg=sg:Select(p,1,1,nil)
			local gc=gg:GetFirst()
			local sp=gc:GetPreviousControler()
			if gc:IsType(TYPE_FIELD) then
				local fc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(gc,p,sp,LOCATION_FZONE,POS_FACEUP,true)
				else
				Duel.ReturnToField(gc)
			end
			if not gc:IsType(TYPE_CONTINUOUS+TYPE_FIELD) then
				Duel.SendtoGrave(gc,REASON_RULE)
			end
			sg:Sub(gg)
		end
	end
	e:GetLabelObject():DeleteGroup()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.retifilter(c,code)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsCode(code)
end
function s.recon(e,tp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.retifilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,code)
	return g:IsExists(Card.IsAbleToRemove,1,nil,tp,POS_FACEUP) and Duel.GetFlagEffect(0,id+1)>0
end
function s.reop(e,tp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	local og=Duel.GetMatchingGroup(s.retifilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,code)
	if og:GetCount()>0 then
		Duel.Remove(og,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	
	end

end
