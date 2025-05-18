--超时空战斗机-天翼
local m=13257377
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.adtg)
	e2:SetOperation(cm.adop)
	c:RegisterEffect(e2)
	
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.spfilter(c)
	return c:IsSetCard(0x351) and c:IsFaceup()
end
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(11,0,aux.Stringid(m,7))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
			local tc=g:GetFirst()
			if tc then
				Duel.Equip(tp,tc,c)
			end
		end
	end
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
	local t2=true
	if chk==0 then return t1 or t2 end
	local op=0
	if t1 or t2 then
		local m1={}
		local n1={}
		local ct=1
		if t1 then m1[ct]=aux.Stringid(m,2) n1[ct]=1 ct=ct+1 end
		if t2 then m1[ct]=aux.Stringid(m,3) n1[ct]=2 ct=ct+1 end
		local sp=Duel.SelectOption(tp,table.unpack(m1))
		op=n1[sp+1]
	end
	e:SetLabel(op)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e)
			or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(c,nseq)
	elseif e:GetLabel()==2 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_UPDATE_DEFENSE)
			e7:SetValue(-500)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e7)
			local e8=Effect.CreateEffect(c)
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_IMMUNE_EFFECT)
			e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e8:SetRange(LOCATION_MZONE)
			e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			e8:SetValue(cm.efilter)
			c:RegisterEffect(e8)
			local e9=Effect.CreateEffect(e:GetHandler())
			e9:SetDescription(aux.Stringid(m,3))
			e9:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e9:SetType(EFFECT_TYPE_SINGLE)
			e9:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e9)
		end
	end
end
function cm.efilter(e,te)
	return e:GetHandler()~=te:GetOwner() and not te:GetOwner():IsType(TYPE_EQUIP)
		and not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
