--炎魔的巨人 苏尔特尔
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddFusionProcFunRep(c,s.ffilter,3,true)
	c:EnableReviveLimit()
    --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
    --atk up
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
    --negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,id+1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.discon)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
    if not s.Des_check then
		s.Des_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.cfi1tr(c)
	return c:IsReason(REASON_DESTROY)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(s.cfi1tr,nil)
	local val=Duel.GetFlagEffectLabel(tp,id)
    local va2=Duel.GetFlagEffectLabel(1-tp,id)
	if val==nil then 
        Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1,#g)
	else
	    Duel.SetFlagEffectLabel(tp,id,val+#g)
    end
    if va2==nil then 
        Duel.RegisterFlagEffect(1-tp,id,RESET_PHASE+PHASE_END,0,1,#g)
	else
	    Duel.SetFlagEffectLabel(1-tp,id,va2+#g)
    end
end
function s.ffilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.filter(c)
	return c:IsSetCard(0x408) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x08)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,0x01,0,1,nil) end
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,0x08)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,0x01,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.val(e,c)
    local val=Duel.GetFlagEffectLabel(c:GetControler(),id)
	if val~=nil then return val*300
    else return 0 end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.defi1ter(c,e)
	return c:GetEquipCount()>0 and c:IsDestructable(e)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=Duel.GetMatchingGroup(s.defi1ter,tp,0x04,0,c,e)
        return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local check=false
    local g=Duel.GetMatchingGroup(s.defi1ter,tp,0x04,0,c,e)
    if #g>0 then
        Duel.Hint(3,tp,502)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        if Duel.Destroy(sg,0x40)>0 then check=true end
    end
	if check and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end