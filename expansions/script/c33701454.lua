--远航之魂 - 璞玉
local m=33701454
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.mfilter,2,4)
	c:EnableReviveLimit()
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_SZONE+LOCATION_FZONE,0)
	e1:SetValue(cm.matval)
	c:RegisterEffect(e1)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Effect 2  
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
end
--link summon
function cm.mfilter(c)
	local b1=c:GetOriginalType()&TYPE_SPELL+TYPE_TRAP~=0 and c:IsLocation(LOCATION_MZONE)
	local b2=c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsLocation(LOCATION_SZONE+LOCATION_FZONE)
	return b1 or b2
end
--extra material
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,true
end
--Effect 1
function cm.f(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 
end
function cm.cf(c)
	return not c:IsForbidden()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_SZONE,0,nil)
	local mg=c:GetLinkedGroup():Filter(cm.cf,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #mg>0
		and Duel.IsPlayerCanDraw(tp,1)
	local b2=#g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0 and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_SZONE,0,nil)
	local mg=c:GetLinkedGroup():Filter(cm.cf,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #mg>0
		and Duel.IsPlayerCanDraw(tp,1)
	local b2=#g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0 and Duel.IsPlayerCanDraw(tp,1)
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))+1
	elseif b1 then opt=1
	elseif b2 then opt=2
	end
	if opt==1 then
		if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=mg:Select(tp,1,1,nil):GetFirst()
		if tc and not tc:IsImmuneToEffect(e) then
			if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	elseif opt==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local flag=bit.bxor(zone,0xff)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		if Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true,s) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end  
	end
end
--Effect 2 
function cm.tf(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tf,tp,LOCATION_SZONE,0,nil)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_SZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsRelateToEffect(e)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.tf,tp,LOCATION_SZONE,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0   
			and b1 and b2 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
