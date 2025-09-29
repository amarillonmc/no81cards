-- 剑客的护身符
local s,id=GetID()
local cg = 0
function s.initial_effect(c)
	-- 效果1：抗性效果
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(s.eqlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
		  local e4=Effect.CreateEffect(c)
  		  e4:SetDescription(aux.Stringid(id,0))
   		  e4:SetType(EFFECT_TYPE_QUICK_O)
   		  e4:SetCode(EVENT_FREE_CHAIN)
		  e4:SetRange(LOCATION_MZONE)
		  e4:SetCountLimit(1)
		  e4:SetCost(s.damcost)
		  e4:SetTarget(s.damtg)
		  e4:SetOperation(s.damop)
		  e4:SetLabel(id)
		  local e5=Effect.CreateEffect(c)
		  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		  e5:SetRange(LOCATION_SZONE)
		  e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		  e5:SetTarget(s.eftg)
		  e5:SetLabelObject(e4)
		  c:RegisterEffect(e5)
		  
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3) 
	
	-- 效果2：提升守备力
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	e9:SetValue(1000)
	c:RegisterEffect(e9)
end
function s.eqlimit(e,c)
	return c:IsSetCard(0x96b)
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
-- 效果3：限定赋予给装备怪兽
function s.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end

-- 效果3：伤害效果相关函数
function s.cfilter(c)
	return c:IsSetCard(0x960) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()  and c:CheckActivateEffect(false,false,false)~=nil
end

function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	cg = g:GetFirst()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end	
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

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=cg
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
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