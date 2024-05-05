--武色O-亮橙武鹰

local id=32000416
local zd=0x3c5
function c32000416.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c32000416.ffilter,2,false)
	
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c32000416.e1limit)
	c:RegisterEffect(e1)
	
	--DesDeckWhenSpSum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetTarget(c32000416.e2tg)
	e2:SetOperation(c32000416.e2op)
	c:RegisterEffect(e2)

    --EquipWhenCaining
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1)
	e3:SetTarget(c32000416.e3tg)
	e3:SetOperation(c32000416.e3op)
	c:RegisterEffect(e3)
	
end

function c32000416.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(zd) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())) and c:IsType(TYPE_MONSTER)
end

--e1

function c32000416.e1limit(e,se,sp,st)
	return se:GetHandler():IsSetCard(zd) and se:GetHandlerPlayer()==e:GetHandlerPlayer()
end

--e2

function c32000416.e2filter(c)
    return c:IsSetCard(zd) and c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function c32000416.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c32000416.e2filter,tp,LOCATION_DECK,0,nil)
    if chk==0 then return g:GetClassCount(Card.GetCode)>0 end

	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end

function c32000416.e2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c32000416.e2filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg1=g:Select(tp,1,1,nil)
	
	Duel.Destroy(tg1,REASON_EFFECT)
end

--e3


function c32000416.e3eqfilter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_MONSTER)
end

function c32000416.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000416.e3eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end

	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end

function c32000416.e3op(e,tp,eg,ep,ev,re,r,rp)
	 if not (Duel.IsExistingMatchingCard(c32000416.e3eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then return end 
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqg=Duel.SelectMatchingCard(tp,c32000416.e3eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local etg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Equip(tp,eqg:GetFirst(),etg:GetFirst())
	
	local c=eqg:GetFirst()
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(true)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end







