--联合作战·部署-代号“余波”
function c79029305.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029305)
	e1:SetTarget(c79029305.target)
	e1:SetOperation(c79029305.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,09029305)
	e2:SetOperation(c79029305.xcop)
	c:RegisterEffect(e2)
end
function c79029305.psfil(c)
	return c:IsSetCard(0xa900) and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())) and c:IsType(TYPE_PENDULUM)
end
function c79029305.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 and Duel.IsExistingMatchingCard(c79029305.psfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,2,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),tp,LOCATION_PZONE)
end
function c79029305.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not Duel.Destroy(dg,REASON_EFFECT)==dg:GetCount() then return end
	Duel.BreakEffect()
	local pg=Duel.SelectMatchingCard(tp,c79029305.psfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,2,2,nil)
	local pc1=pg:GetFirst()
	local pc2=pg:GetNext()
	Duel.MoveToField(pc1,tp,1-tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.MoveToField(pc2,tp,1-tp,LOCATION_PZONE,POS_FACEUP,true)
	local tc1=Duel.GetFieldCard(1-tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c79029305.pendcon)
	e1:SetOperation(c79029305.pendop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc1:RegisterEffect(e1)
	tc1:RegisterFlagEffect(79029305,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc2:GetFieldID())
	tc2:RegisterFlagEffect(79029305,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc1:GetFieldID())
		local fid=c:GetFieldID()
		tc1:RegisterFlagEffect(09029305,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc2:RegisterFlagEffect(09029305,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local sg=Group.FromCards(tc1,tc2)
		sg:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(79029305,4))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(sg)
		e3:SetCondition(c79029305.descon)
		e3:SetOperation(c79029305.thop1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)  
end
function c79029305.desfilter(c,fid)
	return c:GetFlagEffectLabel(09029305)==fid
end
function c79029305.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c79029305.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c79029305.thop1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c79029305.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
function c79029305.pendcon(e,c,og)
	if c==nil then return true end
	local tp=e:GetOwnerPlayer()
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if aux.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if rpz==nil or rpz:GetFieldID()~=c:GetFlagEffectLabel(79029305) then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	if og then
		return og:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
	else
		return Duel.IsExistingMatchingCard(aux.PConditionFilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp,lscale,rscale,eset)
	end
end
function c79029305.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tp=e:GetOwnerPlayer()
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
				local ft=Duel.GetUsableMZoneCount(tp)
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				if ft1>0 then loc=loc|LOCATION_HAND end
				if ft2>0 then loc=loc|LOCATION_EXTRA end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(aux.PConditionFilter,nil,e,tp,lscale,rscale,eset)
	else
		tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
	end
	local ce=nil
	local b1=aux.PendulumChecklist&(0x1<<tp)==0
	local b2=#eset>0
	if b1 and b2 then
		local options={1163}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		if op>0 then
			ce=eset[op]
		end
	elseif b2 and not b1 then
		local options={}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		ce=eset[op+1]
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:FilterSelect(tp,aux.PConditionExtraFilterSpecific,0,ft,nil,e,tp,lscale,rscale,ce)
	if #g==0 then return end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:Reset()
	else
		aux.PendulumChecklist=aux.PendulumChecklist|(0x1<<tp)
	end
	Duel.Hint(HINT_CARD,0,79029305)
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
function c79029305.xcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029305,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(1)
	e1:SetCondition(c79029305.xcon)
	e1:SetOperation(c79029305.xxop1)
	Duel.RegisterEffect(e1,tp)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029305,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(3)
	e1:SetCondition(c79029305.xcon)
	e1:SetOperation(c79029305.xxop2)
	Duel.RegisterEffect(e1,tp)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029305,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(5)
	e1:SetCondition(c79029305.xcon)
	e1:SetOperation(c79029305.xxop3)
	Duel.RegisterEffect(e1,tp)
end
function c79029305.pxfil(c)
	return c:IsRace(RACE_CYBERSE) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c79029305.xcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c79029305.pxfil,tp,LOCATION_MZONE,0,nil)>=e:GetLabel()
end
function c79029305.xxop1(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetMatchingGroupCount(c79029305.pxfil,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,x*800,REASON_EFFECT)
end
function c79029305.xxop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	e1:SetOperation(c79029305.exop1)
	e1:SetLabel(0)
	Duel.RegisterEffect(e1,tp)
end
function c79029305.exop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(79029305,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029305.xxop3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_M1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end









