-- 剑客的秘传
local s,id=GetID()
local cg = 0
function s.initial_effect(c)
	
	-- 效果1：提升攻防
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(s.eqlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(200)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)   
	
		  local e5=Effect.CreateEffect(c)
   		  e5:SetDescription(aux.Stringid(id,0))
   		  e5:SetType(EFFECT_TYPE_QUICK_O)
   		  e5:SetCode(EVENT_FREE_CHAIN)
   		  e5:SetRange(LOCATION_MZONE)
   	 	  e5:SetCountLimit(1)
   	 	  e5:SetCost(s.cost)
		  e5:SetTarget(s.mgtg)
  		  e5:SetOperation(s.mgop)
  		  e5:SetLabel(id)
		 local e4=Effect.CreateEffect(c)
   		 e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		 e4:SetRange(LOCATION_SZONE)
   		 e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
   		 e4:SetTarget(s.eftg)
  		 e4:SetLabelObject(e5)
  		 c:RegisterEffect(e4)
end


function s.filter1(c)
	return c:IsSetCard(0x96b) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)	  		  		   		  		   		 
	end
end
function s.filter(c)
	return c:IsSetCard(0x960) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()  and c:CheckActivateEffect(false,false,false)~=nil
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 1==1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	cg = g:GetFirst()
	Duel.SendtoGrave(cg,REASON_COST)
end
function s.eqlimit(e,c)
	return c:IsSetCard(0x96b)
end
-- 效果2：限定赋予给装备怪兽
function s.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end

-- 效果3：魔法卡适用效果


function s.mgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.ClearTargetCard()
	local tc=cg
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local cost=te:GetCost()
	if cost then cost(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end

function s.mgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  --  local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
  --  Duel.SendtoGrave(g,REASON_EFFECT)
  
	local tc=cg
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local cost=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	--Duel.ClearTargetCard()
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	tc:CreateEffectRelation(te)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then
		local etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc=g:GetNext()
		end
	end
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if etc then	
		etc=g:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=g:GetNext() 
		end
	end
end