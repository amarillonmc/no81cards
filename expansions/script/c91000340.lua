--古战士星神
function c91000340.initial_effect(c)
	c:EnableReviveLimit()   
	--Ritual
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,91000340)
	e1:SetTarget(c91000340.target)
	e1:SetOperation(c91000340.activate)
	c:RegisterEffect(e1)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c91000340.efilter)
	c:RegisterEffect(e7)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c91000340.matcheck)
	c:RegisterEffect(e1)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetValue(c91000340.eaval)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(91000340,1))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(c91000340.tgtg)
	e4:SetOperation(c91000340.tgop)
	c:RegisterEffect(e4)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(91000340,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,29100340)
	e3:SetCondition(c91000340.thcon)
	e3:SetTarget(c91000340.thtg)
	e3:SetOperation(c91000340.thop)
	c:RegisterEffect(e3)
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e41:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e41:SetCode(EVENT_LEAVE_FIELD_P)
	e41:SetOperation(c91000340.regop)
	e41:SetLabelObject(e3)
	c:RegisterEffect(e41)
	--special summon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c91000340.spccost)
	e0:SetOperation(c91000340.spcop)
	c:RegisterEffect(e0)   
	if not c91000340.global_check then
		c91000340.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c91000340.checkop)
		Duel.RegisterEffect(ge1,0)
	end  
end
c91000340.SetCard_Dr_AcWarrior=true 
function c91000340.checkop(e,tp,eg,ep,ev,re,r,rp) 
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.RegisterFlagEffect(rp, 91000340,0,0,0)  
	end  
end
function c91000340.efilter(e,te)
	if te:IsActiveType(TYPE_MONSTER)  then
		local ec=te:GetOwner()
		return e:GetHandler():IsAttribute(ec:GetOriginalAttribute()) and te:GetOwner()~=e:GetOwner()
	else
		return false
	end
end
function c91000340.spccost(e,c,tp)
	return Duel.GetFlagEffect(tp,91000340)==0 
end
function c91000340.spcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)  
	e2:SetValue(c91000340.actlimit)
	Duel.RegisterEffect(e2,tp) 
end
function c91000340.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c91000340.eaval(e,c)
	local ct=0
	local attr=1
	for i=1,7 do
		if e:GetHandler():IsAttribute(attr) then ct=ct+1 end
		attr=attr<<1
	end
	return ct-1
end
function c91000340.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local mg=c:GetMaterial()
	local tc=mg:GetFirst()
	local att=0
	while tc do 
		local att1=tc:GetAttribute()
		att=att|att1
		tc=mg:GetNext()
	end
	--Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
	e1:SetValue(att)
	c:RegisterEffect(e1)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_SET_BASE_ATTACK)
	e12:SetValue(c91000340.eaval1)
	e12:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
	c:RegisterEffect(e12)
end
function c91000340.eaval1(e,c)
	local ct=0
	local attr=1
	for i=1,7 do
		if e:GetHandler():IsAttribute(attr) then ct=ct+1 end
		attr=attr<<1
	end
	return ct*1000
end
function c91000340.filter(c,e,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0  
end
function c91000340.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000340.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,e:GetHandler(),e,tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	local g=Duel.GetMatchingGroup(c91000340.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler(),e,tp)
	local count=g:GetCount()
	if count>=7 then
		count=7
	end
	local t={}
	local i=1
	for i=1,count do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c91000340.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=e:GetLabel()
	local g=Duel.GetMatchingGroup(c91000340.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler(),e,tp)
	local count1=g:GetCount()
	if count1<count then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c91000340.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,count,count,e:GetHandler(),e,tp)
	if not rg or rg:GetCount()==0 then return end
	c:SetMaterial(rg)
	Duel.ReleaseRitualMaterial(rg)
	Duel.BreakEffect()
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP_ATTACK)
	c:CompleteProcedure()
end
function c91000340.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==c and d and (d:GetAttribute()&c:GetAttribute()~=0) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,d,1,0,0)
end
function c91000340.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Damage(1-tp,1000,REASON_EFFECT)~=0 then
		local d=Duel.GetAttackTarget()
		if d:IsRelateToBattle() and d:GetAttribute()&c:GetAttribute()~=0 then
			Duel.SendtoGrave(d,REASON_EFFECT)
		end
	end
end
function c91000340.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=0
	local attr=1
	for i=1,7 do
		if e:GetHandler():IsAttribute(attr) then ct=ct+1 end
		attr=attr<<1
	end
	e:GetLabelObject():SetLabel(ct)
end
function c91000340.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (e:GetLabel()>0 or c:IsPreviousLocation(LOCATION_HAND))and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0
end
function c91000340.thfilter(c)
	return c:IsAbleToHand()
end
function c91000340.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c91000340.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c91000340.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local ct=0
	if c:IsPreviousLocation(LOCATION_HAND) then
		ct=1
	else
		ct=e:GetLabel()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c91000340.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetChainLimit(c91000340.chlimit)
end
function c91000340.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c91000340.chlimit(e,ep,tp)
	return tp==ep
end