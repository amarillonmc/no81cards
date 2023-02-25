--出航的罪人 巴巴洛丝
local m=60001210
local cm=_G["c"..m]
cm.name="出航的罪人 巴巴洛丝"
function cm.initial_effect(c)
	--爆能强化
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(cm.sumcon)
	e3:SetOperation(cm.sumop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	--进化
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION) 
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCost(cm.drcost) 
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)  
	--入场曲
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
   -- if not cm.global_check then
	 --   cm.global_check=true
	  --  local ge1=Effect.CreateEffect(c)
	  --  ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	  --  ge1:SetCode(EVENT_CHAIN_SOLVED)
	  --  ge1:SetOperation(cm.checkop)
	  --  Duel.RegisterEffect(ge1,0)
  --  end
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND) 
	e4:SetCountLimit(1)
	e4:SetCost(cm.spcost)
	e4:SetCondition(cm.spcon2)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
cm.named_with_treasure=true 
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup())
end
function cm.sumcon(e,c,minc)
	if c==nil then return true end
	local min=1
	if minc>=1 then min=minc end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:IsLevelAbove(5) and Duel.CheckTribute(c,min,10,mg)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local min=1
	if minc>=1 then min=minc end
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,min,10,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function cm.mgfilter(c,e,tp,fusc)
	return bit.band(c:GetReason(),0x12)==0x12 and c:GetReasonCard()==fusc
		and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())  
end
function cm.mgfilter2(c,e,tp,fusc)
	return not c:IsDisabled() and c:IsAbleToDeck() and c:IsCode(1231611)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ag=c:GetMaterial()
	if chk==0 then return (ag and ag:GetCount()>0 and ag:IsExists(cm.mgfilter,2,nil,e,tp,c))
		or Duel.IsExistingMatchingCard(cm.mgfilter2,tp,LOCATION_GRAVE,0,2,nil) end
	if not (ag and ag:GetCount()>0 and ag:IsExists(cm.mgfilter,2,nil,e,tp,c)) then 
		local g=Duel.SelectMatchingCard(tp,cm.mgfilter2,tp,LOCATION_GRAVE,0,2,2,nil) 
		Duel.SendtoDeck(g,nil,2,REASON_COST)
		return 
	end 
	if Duel.IsExistingMatchingCard(cm.mgfilter2,tp,LOCATION_GRAVE,0,2,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then 
		local g=Duel.SelectMatchingCard(tp,cm.mgfilter2,tp,LOCATION_GRAVE,0,2,2,nil) 
		Duel.SendtoDeck(g,nil,2,REASON_COST)
		return 
	end 
	local dc=ag:FilterSelect(tp,cm.mgfilter,2,2,nil,e,tp,c)
	Duel.SendtoDeck(dc,nil,2,REASON_COST)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(c:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(c:GetBaseDefense()*2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2) 
	end 
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
   -- for i=1,ev do
	 --   local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	 --   local w=te:GetHandler()
	 --   if tgp==tp and w:IsSetCard(0x6a6) then
	 -- return Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1000)
	 --   end  
   -- end
--end
function cm.thfilter(c)
	return c:IsCode(60001221) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	if Duel.GetFlagEffect(tp,60001211)>=7 then 
		if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if Duel.GetFlagEffect(tp,60001211)>=7 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x6a6) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER+TYPE_NORMAL,0,0,0,0,0,POS_FACEDOWN_DEFENSE)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()<1 then return end
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	Duel.RegisterFlagEffect(tp,60001211,RESET_PHASE+PHASE_END,0,1000)
	
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
end










