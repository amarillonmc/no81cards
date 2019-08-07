--火龙
function c10150071.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,15981690,aux.FilterBoolFunction(Card.IsFusionCode,58071123),1,100,true,true)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150071,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10150071.con)
	e2:SetTarget(c10150071.tg)
	e2:SetOperation(c10150071.op)
	c:RegisterEffect(e2)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c10150071.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c10150071.valcheck(e,c)
	local ct=e:GetHandler():GetMaterial():FilterCount(Card.IsFusionCode,nil,58071123)
	e:GetLabelObject():SetLabel(ct)
end
function c10150071.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c10150071.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	if ct==1 then
	   e:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	   Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	elseif ct==2 then
	   e:SetCategory(CATEGORY_ATKCHANGE)
	else
	   e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	   local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	   dg:AddCard(e:GetHandler())
	   Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0) 
	   Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)	  
	end
end
function c10150071.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	if ct==1 then
	   local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	   if Duel.Damage(1-tp,1000,REASON_EFFECT)~=0 and g:GetCount()>0 then
		  Duel.BreakEffect()
		  for tc in aux.Next(g1) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetAttack()/2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		  end
	   end
	elseif ct==2 then
	   local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	   if g2:GetCount()>0 then
		  for tc in aux.Next(g2) do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK_FINAL)
			e2:SetValue(tc:GetAttack()*2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
		  end
	   end
	else
	   local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	   if c:IsRelateToEffect(e) then
		  dg:AddCard(c) 
	   end
	   if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		  Duel.BreakEffect()
		  Duel.Draw(tp,1,REASON_EFFECT)
	   end
	end
end

