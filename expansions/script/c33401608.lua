--幻音之观测者 万由里
local m=33401608
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
XY.mayuri(c)
	  --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true) 
--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(EFFECT_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,m)
	e7:SetTarget(cm.netg)
	e7:SetOperation(cm.neop)
	c:RegisterEffect(e7)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x341) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end

function cm.ckfilter(c)
	return  (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and Duel.IsExistingMatchingCard(cm.ckfilter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function cm.ckfilter2(c,at)
	return (c:IsAttackAbove(1) or c:IsDefenseAbove(1) or aux.disfilter1(c))   and  c:GetAttribute()&at~=0
end
function cm.netg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) and cm.ckfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.ckfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.ckfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thfilter(c,at)
	return c:IsSetCard(0x6344) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(at) and c:IsAbleToHand()
end
function cm.neop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and (tc:IsFaceup() or tc:IsLocation(LOCATION_GRAVE)) and Duel.IsExistingMatchingCard(cm.ckfilter2,tp,0,LOCATION_MZONE,1,nil,tc:GetAttribute())  then 
		local g=Duel.GetMatchingGroup(cm.ckfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
		local tc2=g:GetFirst()
		while tc2 do		  
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_SET_ATTACK_FINAL)
			e0:SetValue(0)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e0)
			local e1=e0:Clone()
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc2:RegisterEffect(e1)
			Duel.NegateRelatedChain(tc2,RESET_TURN_SET)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e3)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(RESET_TURN_SET)
			tc2:RegisterEffect(e2)	 
			tc2=g:GetNext()
		end 
	end
end

