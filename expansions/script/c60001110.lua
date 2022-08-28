--圣兽装骑·骸-神社
local m=60001110
local cm=_G["c"..m]

function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),6,4,nil,nil,99)
	c:EnableReviveLimit()
	--spsummonfromextrafirst
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e0:SetCode(EVENT_CHAIN_SOLVING) 
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,m)
	e0:SetCondition(cm.dscon) 
	e0:SetOperation(cm.dsop)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.sprcon)
	e1:SetOperation(cm.sprop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCondition(cm.crcon)
	e3:SetTarget(cm.crtg)
	e3:SetOperation(cm.crop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.seqtg)
	e4:SetOperation(cm.seqop)
	c:RegisterEffect(e4)
	--Checkgrave
	local e27=Effect.CreateEffect(c)
	e27:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e27:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e27:SetCode(EVENT_ADJUST)
	e27:SetOperation(cm.gravecheckop)
	Duel.RegisterEffect(e27,tp)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard(0x62e) then
		Duel.RegisterFlagEffect(rc:GetSummonPlayer(),600011101,0,RESET_PHASE+PHASE_END,1)
	end
end

function cm.gravecheckop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then
		e:GetHandler():RegisterFlagEffect(0,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60001111,0))
	end
end

function cm.dscon(e,tp,eg,ep,ev,re,r,rp) 
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x962e) and te:IsActiveType(TYPE_MONSTER) and p==tp and rp==1-tp
end

function cm.xovfil(c) 
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x62e) and c:GetOverlayCount()==0 and c:IsCanOverlay()
end

function cm.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.xovfil,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=Duel.SelectMatchingCard(tp,cm.xovfil,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Overlay(c,tc)
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		c:RegisterFlagEffect(600011100,RESET_EVENT+EVENT_SPSUMMON_NEGATED,0,0)
	end
end

function cm.sprcon(e,c,tp)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cm.xovfil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,600011101)>=4
end

function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,cm.xovfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Overlay(c,tc)
	c:RegisterFlagEffect(600011100,RESET_EVENT+EVENT_SPSUMMON_NEGATED,0,0)
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(600011100)~=0 then
		e:GetHandler():CompleteProcedure()
		e:GetHandler():ResetFlagEffect(600011100)
	end
end

function cm.crcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) or Duel.GetFlagEffect(tp,m)==0
end

function cm.crtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetOverlayCount()>0 and 
	(c:IsLocation(LOCATION_MZONE) or ((c:IsCanBeSpecialSummoned(e,0,tp,false,false)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) end
	c:ResetFlagEffect(m)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.RegisterFlagEffect(tp,m,0,0,1)
		c:RegisterFlagEffect(m,0,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
	end
end

function cm.crop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and (c:GetOverlayCount()>0 or c:GetFlagEffect(m)~=0) then
		if c:GetOverlayCount()>0 then
			c:RemoveOverlayCard(tp,c:GetOverlayCount(),c:GetOverlayCount(),REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(cm.chainop)
		Duel.RegisterEffect(e1,tp)
		if c:GetFlagEffect(m)~=0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.splimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp) 
end

function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end

function cm.chainlm(e,ep,tp)
	return tp==ep
end

function cm.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function cm.consfilter(c)
	return c:IsSetCard(0x62e) and c:IsSummonLocation(LOCATION_EXTRA)
end

function cm.tgsfilter(tp)
	local g=Duel.GetMatchingGroup(cm.consfilter,tp,LOCATION_MZONE,0,nil)
	local g1=Group.CreateGroup()
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if tc:GetColumnGroup():GetCount()>0 then g1:Merge(tc:GetColumnGroup()) end
			tc=g:GetNext()
		end
	end
	return g1
end

function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return cm.tgsfilter(tp):GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,cm.tgsfilter(tp),cm.tgsfilter(tp):GetCount(),0,0)
end

function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	if cm.tgsfilter(tp):GetCount()>0 then
		local g=cm.tgsfilter(tp)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end