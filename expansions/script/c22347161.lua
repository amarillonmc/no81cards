local m=22347161
local cm=_G["c"..m]
cm.name="蕾宗忍者杀手·小蓟"
function cm.initial_effect(c)
	--link summon
	local e11=aux.AddLinkProcedure(c,cm.lmatfilter,3,3,cm.lcheck)
	e11:SetProperty(e11:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(22347161)
	e0:SetRange(0xff)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--Equip Link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(cm.matval)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(cm.mattg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--macro cosmos
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(0xff)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	e3:SetLabelObject(e11)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(cm.atkval)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.tetg)
	e6:SetOperation(cm.teop)
	c:RegisterEffect(e6)
	--workaround
	if not cm.mat_hack_check then
		cm.mat_hack_check=true
		_lzr_GetLinkMaterials=Auxiliary.GetLinkMaterials
		function Auxiliary.GetLinkMaterials(tp,f,lc,e)
			local mg=_lzr_GetLinkMaterials(tp,f,lc,e)
			local mg3=Duel.GetMatchingGroup(c22347161.lzrlinkfilter,tp,LOCATION_SZONE,0,nil,f,lc,e)
			if mg3:GetCount()>0 then mg:Merge(mg3) end
			return mg
		end
	end
end
c22347161.lzrlinkfilter=function(c,f,lc,e)
	return c:IsFacedown()
		and c:IsCanBeLinkMaterial(lc) and c:IsSetCard(0x3705) and lc:IsHasEffect(22347161)
end
function cm.lmatfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsLinkType(TYPE_EFFECT) and c:IsFaceup()
end
function cm.lcheck(g,lc)
	local b1=(g:IsExists(Card.IsLinkSetCard,1,nil,0x5705) and (not g:IsExists(cm.fdmatfilter,1,nil)))
	local b2=((not g:IsExists(Card.IsLocation,1,nil,LOCATION_SZONE)) and (not g:IsExists(cm.fdmatfilter,1,nil)))
	return b1 or b2
end
function cm.fdmatfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFacedown()
end
function cm.mattg(e,c)
	return c:IsFacedown() and c:IsSetCard(0x3705) and c:IsAbleToHand()
end
function cm.mfilter(c,sc)
	return c:IsLocation(LOCATION_MZONE) and c:IsLinkSetCard(0x5705)
end
function cm.exmfilter(c,sc)
	return c:IsLocation(LOCATION_SZONE) and c==sc
end
function cm.matval(e,lc,mg,c,tp)
	if not lc:IsHasEffect(22347161) then return false,nil end
	return true,not mg or mg:IsExists(cm.mfilter,1,nil,c) and not mg:IsExists(cm.exmfilter,1,nil,c)
end

function cm.repfilter(c,tp,le)
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:IsReason(REASON_LINK) and c:GetReasonCard():IsHasEffect(22347161)
		and c:IsAbleToHand() and c:GetReasonEffect()==le
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local le=e:GetLabelObject()
	if chk==0 then return bit.band(r,REASON_LINK)~=0
		and eg:IsExists(cm.repfilter,1,nil,tp,le) end
	if bit.band(r,REASON_LINK)~=0
		and eg:IsExists(cm.repfilter,1,nil,tp,le) then
		local g=eg:Filter(cm.repfilter,nil,tp,le)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_HAND)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.thcon)
		e1:SetOperation(cm.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		return true
	else return false end
end
function cm.repval(e,c)
	return false
end
function cm.thfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thfilter,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local tc=g:GetFirst()
	while tc do
		tc:ResetFlagEffect(m)
		tc=g:GetNext()
	end
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsPublic,c:GetControler(),LOCATION_HAND,0,nil)*1000
end
function cm.setfilter(c,tp)
	return (c:IsType(TYPE_QUICKPLAY) or c:GetType()==TYPE_SPELL) and c:IsSSetable(true) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceupEx() and c:IsSetCard(0x3705)
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and cm.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and e:GetHandler():IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	if g and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.lfilter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x5705)
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
		if Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and e:GetHandler():IsLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(cm.lfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,cm.lfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
			if tc then Duel.LinkSummon(tp,tc,nil) end
		end
	end
end