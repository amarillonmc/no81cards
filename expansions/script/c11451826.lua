--破坏神 菈·芭斯瓦尔德
local cm,m=GetID()
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e00=Effect.CreateEffect(c)
	e00:SetDescription(1165)
	e00:SetType(EFFECT_TYPE_FIELD)
	e00:SetCode(EFFECT_SPSUMMON_PROC)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetRange(LOCATION_EXTRA)
	e00:SetCondition(function(...) return aux.XyzLevelFreeCondition(cm.mfilter,cm.xyzcheck,2,2)(...) and cm[0]==1 and cm[1]==2 end)
	e00:SetTarget(aux.XyzLevelFreeTarget(cm.mfilter,cm.xyzcheck,2,2))
	e00:SetOperation(aux.XyzLevelFreeOperation(cm.mfilter,cm.xyzcheck,2,2))
	e00:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e00)
	--aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2)
	--spsummon condition
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(cm.splimit)
	c:RegisterEffect(e11)
	--xyz in event
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetLabelObject(e00)
	e0:SetCondition(cm.xyzcon)
	e0:SetOperation(cm.xyzop)
	c:RegisterEffect(e0)
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--xyz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.descon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(cm.leave)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetLabel(0,0,0,0)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or st&SUMMON_TYPE_XYZ~=SUMMON_TYPE_XYZ or (st&SUMMON_TYPE_XYZ==SUMMON_TYPE_XYZ and not se and cm[0]==1 and cm[1]==2)
end
function cm.mfilter(c,xyzc)
	return (not xyzc or cm[xyzc:GetControler()]) and c:IsXyzType(TYPE_MONSTER) and (c:IsXyzLevel(xyzc,8) or c:IsRank(8))
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a1,a2=Duel.GetFlagEffect(0,11451481),Duel.GetFlagEffect(0,11451482)
	local b1,b2=Duel.GetFlagEffect(1,11451481),Duel.GetFlagEffect(1,11451482)
	local a11,a22,b11,b22=e:GetLabel()
	if a1~=a11 or a2~=a22 or b1~=b11 or b2~=b22 then
		--Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,re,r,rp,ep,ev)
		cm[0]=1
		cm[1]=cm[1]+1
		Duel.Hint(HINT_CARD,0,11451483)
	else
		cm[0]=0
	end
	e:SetLabel(a1,a2,b1,b2)
end
function cm.filter3(c)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	return cm[0]==1 and cm[1]==2 and e:GetHandler():IsXyzSummonable(mg)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if cm[0]==0 then return end
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local mg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	cm[0]=0
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		te:GetTarget()(te,tp,eg,ep,ev,re,r,rp,1,c,mg,2,2)
		te:GetOperation()(te,tp,eg,ep,ev,re,r,rp,c,mg,2,2)
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_OVERLAY) then Duel.ShuffleHand(tp) end
		--Duel.XyzSummon(tp,e:GetHandler(),mg,2,2)
	end
end
function cm.xfilter(c,tp,g)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and g:IsExists(Card.IsAttribute,1,c,c:GetAttribute())
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local xg=Duel.GetOverlayGroup(tp,1,1)
	g:Merge(xg)
	local tg=eg:Filter(cm.xfilter,nil,1-tp,g)
	return #tg>0 and not eg:IsContains(e:GetHandler())
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local xg=Duel.GetOverlayGroup(tp,1,1)
	g:Merge(xg)
	local tg=eg:Filter(cm.xfilter,nil,1-tp,g)
	Duel.SetTargetCard(tg)
	Duel.HintSelection(tg)
end
function cm.imfilter(c,e)
	return c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and c:IsCanOverlay()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local cg=tg:Filter(cm.imfilter,nil,e)
	if c:IsRelateToEffect(e) and #cg>0 then
		Duel.Overlay(c,cg)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function Group.ForEach(group,func,...)
	if aux.GetValueType(group)=="Group" and group:GetCount()>0 then
		local d_group=group:Clone()
		for tc in aux.Next(d_group) do
			func(tc,...)
		end
	end
end
function cm.leave(e,tp,eg,ep,ev,re,r,rp)
	local b1=r&REASON_SUMMON>0 or (re and (re:GetCode()==EFFECT_SUMMON_PROC or re:GetCode()==EFFECT_SUMMON_COST or re:GetCode()==EVENT_SUMMON)) or Duel.CheckEvent(EVENT_SUMMON)
	local b2=re and (re:GetCode()==EFFECT_SET_PROC or re:GetCode()==EFFECT_MSET_COST)
	local b3=(re and (re:GetCode()==EFFECT_SPSUMMON_PROC or re:GetCode()==EFFECT_SPSUMMON_PROC_G or re:GetCode()==EFFECT_SPSUMMON_COST or re:GetCode()==EVENT_SPSUMMON)) or Duel.CheckEvent(EVENT_SPSUMMON) --and (not re:GetHandler():IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp,tp,nil,re:GetHandler())==Duel.GetLocationCountFromEx(tp,tp,nil,re:GetHandler(),0x1f))
	local c=e:GetHandler()
	local tp=c:GetPreviousControler()
	local og=c:GetOverlayGroup()
	local tg=og:Filter(cm.spfilter,nil,e,tp)
	if #tg==0 then return end
	if b1 or b2 or b3 then
		tg:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_REMOVE,0,1,c:GetFieldID())
		if b1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SUMMON_SUCCESS)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetLabel(c:GetFieldID())
			e1:SetOperation(cm.leave2)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_SUMMON_NEGATED)
			Duel.RegisterEffect(e2,tp)
			e1:SetLabelObject(e2)
			e2:SetLabelObject(e1)
		elseif b2 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_MSET)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetLabel(c:GetFieldID())
			e1:SetOperation(cm.leave2)
			Duel.RegisterEffect(e1,tp)
		elseif b3 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetLabel(c:GetFieldID())
			e1:SetOperation(cm.leave2)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_SPSUMMON_NEGATED)
			Duel.RegisterEffect(e2,tp)
			e1:SetLabelObject(e2)
			e2:SetLabelObject(e1)
		end
		return
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.ffilter(c,fid)
	return c:GetFlagEffect(m)>0 and fid==c:GetFlagEffectLabel(m)
end
function cm.leave2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te and aux.GetValueType(te)=="Effect" then te:Reset() end
	e:Reset()
	local og=Duel.GetMatchingGroup(cm.ffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e:GetLabel())
	local tg=og:Filter(cm.spfilter,nil,e,tp)
	if #tg==0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if #tg>ft then
		tg=tg:Select(tp,ft,ft,nil)
	end
	if #tg>0 then
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end