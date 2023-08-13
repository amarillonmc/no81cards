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
	e00:SetCondition(aux.XyzLevelFreeCondition(cm.mfilter,cm.xyzcheck,2,2))
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
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or st&SUMMON_TYPE_XYZ~=SUMMON_TYPE_XYZ or (st&SUMMON_TYPE_XYZ==SUMMON_TYPE_XYZ and not se)
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
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local mg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		te:GetTarget()(te,tp,eg,ep,ev,re,r,rp,1,c,mg,2,2)
		te:GetOperation()(te,tp,eg,ep,ev,re,r,rp,c,mg,2,2)
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_OVERLAY) then Duel.ShuffleHand(tp) end
		--Duel.XyzSummon(tp,e:GetHandler(),mg,2,2)
	end
end
function cm.xfilter(c,tp,g)
	return c:IsFaceup() and c:IsControler(tp) and g:IsExists(Card.IsAttribute,1,nil,c:GetAttribute())
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
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.SetTargetCard(g)
end
function cm.imfilter(c,e)
	return c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
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
function cm.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousControler(tp) then
		local og=c:GetOverlayGroup()
		local tg=og:Filter(cm.spfilter,nil,e,tp)
		if #tg==0 then return end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=tg:Select(tp,ft,ft,nil)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end