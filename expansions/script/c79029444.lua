--守林人·生命之地收藏-枯柏
function c79029444.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c79029444.lcheck)
	c:EnableReviveLimit()
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(79029041)
	c:RegisterEffect(e0) 
	--Overlay
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c79029444.ovtg)
	e1:SetOperation(c79029444.ovop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029444)
	e2:SetCondition(c79029444.discon)
	e2:SetTarget(c79029444.distg)
	e2:SetOperation(c79029444.disop)
	c:RegisterEffect(e2)
end
function c79029444.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa906)
end
function c79029444.ovfil(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xa900) and Duel.IsExistingMatchingCard(c79029444.oxfil,tp,LOCATION_DECK,0,1,nil)
end
function c79029444.oxfil(c)
	return c:IsSetCard(0xa900) and c:IsCanOverlay()
end
function c79029444.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c79029444.ovfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end
	Duel.SelectTarget(tp,c79029444.ovfil,tp,LOCATION_MZONE,0,1,1,nil)
	Debug.Message("组队完成。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029444,1))  
end
function c79029444.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c79029444.oxfil,tp,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and g:GetCount()>0 then 
	sg=g:Select(tp,1,1,nil)
	Duel.Overlay(tc,sg)
	end
end
function c79029444.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
end
function c79029444.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fe=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	if chk==0 then return e:GetHandler():GetLinkedGroupCount()>0 and rp~=tp and (fe:GetHandler():IsSetCard(0xc90e) or fe:GetHandler():IsSetCard(0xb90d) or fe:GetHandler():IsSetCard(0xa900))  end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,0,0,0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetLabel(ev)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029444.cicon)
	e1:SetOperation(c79029444.ciop)
	e1:SetReset(RESET_EVENT+RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c79029444.disop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("现在进行索敌。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029444,2))  
	local x=e:GetHandler():GetLinkedGroupCount()
	local dg=Group.CreateGroup()
	for i=1,ev do
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	dg:AddCard(tc)
	end
	 local lg=dg:Select(tp,1,x,nil)
	 local lc=lg:GetFirst()
	 while lc do
	 lc:RegisterFlagEffect(79029444,RESET_CHAIN,0,1)
	 lc=lg:GetNext()
	 end
	Debug.Message("瞄准。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029444,3))  
	for i=1,ev do
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	local p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	if tc:GetFlagEffect(79029444)~=0 then
	Duel.NegateActivation(i)
	end
	end
	local x1=Duel.GetCurrentChain()*2
	if Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) and Duel.IsPlayerCanDiscardDeck(tp,x1) and Duel.SelectYesNo(tp,aux.Stringid(79029444,0)) then
	Debug.Message("发射。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029444,5))  
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
	Duel.DiscardDeck(tp,x1,REASON_EFFECT) 
	Duel.Damage(1-tp,x1*200,REASON_EFFECT)  
	end
end
function c79029444.cicon(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetLinkedGroupCount()
	return e:GetLabel()+1==ev and Duel.IsPlayerCanDraw(tp,x)
end
function c79029444.ciop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我需要更多的力量。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029444,4))  
	local x=e:GetHandler():GetLinkedGroupCount()
	Duel.Draw(tp,x,REASON_EFFECT)
	e:Reset()
end










