local m=4877310
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(cm.cost)
    e1:SetTarget(cm.destg)
    e1:SetOperation(cm.desop)
    c:RegisterEffect(e1)
end
function cm.costfilter(c,tp)
    return c:GetOriginalType()&TYPE_MONSTER~=0 and (c:IsControler(tp) or c:IsFaceup())
end 
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   e:SetLabel(1)
    return true
end
function cm.matfilter2(c)
    return c:IsType(TYPE_MONSTER) 
end
function cm.fselect(g,tp)
    return Duel.IsExistingMatchingCard(cm.matfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,g:GetCount(),sg)
        and Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
     local ct=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_ONFIELD,nil)
	  if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
    local g1=Duel.GetReleaseGroup(tp,true):Filter(cm.costfilter,e:GetHandler(),tp)
    if chk==0 then return ct>0 and #g1>0  end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local rg=g1:Select(tp,1,ct,nil)
        Auxiliary.UseExtraReleaseCount(rg,tp)
        Duel.Release(rg,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local tc=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,rg:GetCount(),nil)
	local rc=tc:GetFirst()
	while e:IsHasType(EFFECT_TYPE_ACTIVATE) and rc do
        Duel.SetChainLimit(cm.limit(rc))
		rc=tc:GetNext()
    end
end
function cm.limit(c)
    return  function (e,lp,tp)
                return e:GetHandler()~=c
            end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(tg,REASON_EFFECT)
    
end