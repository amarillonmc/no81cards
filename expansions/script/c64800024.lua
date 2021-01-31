--杰作拼图8000-『塔』
local m=64800024
local cm=_G["c"..m]
function cm.initial_effect(c)
   aux.AddFusionProcFunRep(c,cm.ffilter,3,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	  --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
  --negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
  --negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.discon2)
	e3:SetTarget(cm.distg2)
	e3:SetOperation(cm.disop2)
	c:RegisterEffect(e3)
   --spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(cm.target2)
	e4:SetOperation(cm.activate2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return  not sg or not (sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()) or  sg:IsExists(Card.IsRace,1,c,c:GetRace()))
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (bit.band(loc,LOCATION_HAND)~=0 or  bit.band(loc,LOCATION_GRAVE)~=0) and re:GetHandler():IsAbleToRemove()	
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if  c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and   Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsChainDisablable(ev)
	and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then  
	Duel.NegateEffect(ev)
	end
end

function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_ONFIELD)~=0  and Duel.IsChainDisablable(ev)
end
function cm.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if   rc:IsRelateToEffect(re) and Duel.IsChainDisablable(ev) and   Duel.NegateEffect(ev)~=0   then  
	Duel.Destroy(rc,REASON_EFFECT)
	end
end

function cm.filter(c,e)
	return  (not e or c:IsRelateToEffect(e))
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return eg:IsExists(cm.filter,1,nil,nil) end
	local g=eg:Filter(cm.filter,nil,nil)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
   Duel.Destroy(eg,REASON_EFFECT)
end










