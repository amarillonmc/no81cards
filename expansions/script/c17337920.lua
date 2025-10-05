--·莱茵哈鲁特·范·阿斯特雷亚·
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(s.spcost)
	c:RegisterEffect(e0)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(s.sumsuc)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)
	--cannot release
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UNRELEASABLE_SUM)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e7)
	--cannot be material
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e9)
	local e10=e6:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e10)
	local e11=e6:Clone()
	e11:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e11)
	--cannot activate
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CANNOT_ACTIVATE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(0,1)
	e12:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsBattlePhase()
	end)
	e12:SetValue(function(e,re,tp)
		local loc=re:GetActivateLocation()
		return loc&LOCATION_ONFIELD+LOCATION_GRAVE~=0
	end)
	c:RegisterEffect(e12)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_DISABLE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_GRAVE)
	e13:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsBattlePhase()
	end)
	e13:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	c:RegisterEffect(e13)
	--spsummon
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(1118)
	e14:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e14:SetCode(EVENT_LEAVE_FIELD)
	e14:SetProperty(EFFECT_FLAG_DELAY)
	e14:SetCondition(s.spcon)
	e14:SetTarget(s.sptg)
	e14:SetOperation(s.spop)
	c:RegisterEffect(e14)
	--atk & def
	local e15=Effect.CreateEffect(c)
	e15:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e15:SetType(EFFECT_TYPE_QUICK_O)
	e15:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e15:SetCondition(s.atkcon)
	e15:SetTarget(s.atktg)
	e15:SetOperation(s.atkop)
	c:RegisterEffect(e15)
end
function s.spcost(e,c,tp,st)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function s.fselect0(g,tp,d)
	if not (Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x5f52) and c:IsFaceupEx() and c:IsAbleToGraveAsCost() end,tp,0,LOCATION_ONFIELD,1,nil) and d>0) then
		return Duel.GetMZoneCount(tp,g,tp)>0 and g:IsExists(function(c) return c:IsSetCard(0x5f52) and c:IsFaceupEx() end,1,nil)
	else
		return Duel.GetMZoneCount(tp,g,tp)>0
	end
end
function s.fselect1(g,tp)
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local count=p2-p1
	if count<0 then count=p1-p2 end
	local d=math.floor(count/1000)
	if d>9 then d=9 end
	if not Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x5f52) and c:IsFaceupEx() and c:IsAbleToGraveAsCost() end,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) then 
		return g:FilterCount(Card.IsControler,nil,1-tp)<=d and g:IsExists(function(c) return c:IsSetCard(0x5f52) and c:IsFaceupEx() end,1,nil)
	else 
		return g:FilterCount(Card.IsControler,nil,1-tp)<=d
	end
end
function s.fselect2(g,tp,sg1)
	local check=false
	if #sg1>0 then 
		if sg1:IsExists(Card.IsSetCard,1,nil,0x5f52) then
			check=true
		end
	end
	if check then
		return Duel.GetMZoneCount(tp,g,tp)>0
	else
		return Duel.GetMZoneCount(tp,g,tp)>0 and g:IsExists(function(c) return c:IsSetCard(0x5f52) and c:IsFaceupEx() end,1,nil)
	end
end
function s.spcfilter(c)
	return c:IsAbleToGraveAsCost()
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=10
	local ct2=Duel.GetFlagEffect(tp,17337900)
	if ct2>0 then 
		if ct2>3 then ct2=3 end
		local ct3=ct-ct2*3
	end
	local mg1=Duel.GetMatchingGroup(s.spcfilter,tp,0,LOCATION_ONFIELD,nil)
	local mg2=Duel.GetMatchingGroup(s.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local count=p2-p1
	if count<0 then count=p1-p2 end
	local d=math.floor(count/1000)
	if d>9 then d=9 end
	if d > #mg1 then d = #mg1 end
	if d + #mg2 < ct then return false end
	return mg2:CheckSubGroup(s.fselect0,ct3,ct3,tp,d)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local ct0=10
	local ct=ct0
	local ct2=Duel.GetFlagEffect(tp,17337900)
	if ct2>0 then 
		if ct2>3 then ct2=3 end
		ct=ct-ct2*3
		e:SetLabel(ct)
	end
	local sg=Group.CreateGroup()
	local mg1=Duel.GetMatchingGroup(s.spcfilter,tp,0,LOCATION_ONFIELD,nil)
	local mg2=Duel.GetMatchingGroup(s.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	local sg1=Group.CreateGroup()
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local count=p2-p1
	if count<0 then count=p1-p2 end
	local d=math.floor(count/1000)
	if d>9 then d=9 end
	if d > #mg1 then d = #mg1 end
	if ct and d and d>0 and #mg1>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		sg1=mg1:SelectSubGroup(tp,s.fselect1,true,1,d,tp)
		if not sg1 or (#sg1>0 and #sg1 + #mg2 < ct) or (not sg1:IsExists(Card.IsSetCard,1,nil,0x5f52) and ct==1) then
			if sg1 and (#sg1 + #mg2 < ct or (not sg1:IsExists(Card.IsSetCard,1,nil,0x5f52) and ct==1)) then
				Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id,0))
			end
		return false end
		sg:Merge(sg1)
		if #sg1>0 then ct=ct-#sg1 end
	end
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=mg2:SelectSubGroup(tp,s.fselect2,true,ct,ct,tp,sg1)
		sg:Merge(sg2)
	end
	if sg and (#sg==ct0 or (#sg==e:GetLabel() and ct2>0)) then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function s.exfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:GetBaseAttack()>0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
		return #g>0
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local sum=g:GetSum(Card.GetBaseAttack)
	local c=e:GetHandler()
	if c:IsRelateToBattle() and c:IsFaceup() and sum>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(sum)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end