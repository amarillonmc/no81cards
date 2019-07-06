--堕入虚毒duel.ge
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700717
local cm=_G["c"..m]
function cm.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DESTROY+CATEGORY_COUNTER+CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.damtg)
	c:RegisterEffect(e1)	
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x144b) and c:GetCounter(0x144b)>0
end
function cm.desfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAttackAbove(1) and rsve.addcounter(tp,c:GetLevel(),0,c)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,m)+1
	local b1=Duel.GetCounter(tp,1,1,0x144b)>0
	local b2=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local sel={}
	for i=1,ct do
	   local ops={}
	   local opval={}
	   local off=1
	   if #sel==ct then break end
	   if #sel>=1 and (b1 or b2 or b3) and not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then break end
	   if b1 then
		  ops[off]=aux.Stringid(m,0)
		  opval[off-1]=1
		  off=off+1
	   end
	   if b2 then
		  ops[off]=aux.Stringid(m,1)
		  opval[off-1]=2
		  off=off+1
	   end
	   if b3 then
		  ops[off]=aux.Stringid(m,2)
		  opval[off-1]=3
		  off=off+1
	   end
	   local op=Duel.SelectOption(tp,table.unpack(ops))
	   sel[#sel+1]=opval[op]
	   if opval[op]==1 then b1=false end
	   if opval[op]==2 then b2=false end
	   if opval[op]==3 then b3=false end 
	end
	e:SetOperation(cm.damop(sel))
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cm.damop(sel)
	return function(e,tp,eg,ep,ev,re,r,rp)
	   for _,ct in ipairs(sel) do
		   if ct==1 then 
			  local ct=Duel.GetCounter(tp,1,1,0x144b)
			  Duel.Damage(1-tp,ct*50,REASON_EFFECT)
		   elseif ct==2 then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			  local tc=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
			  if tc then
				 local ct=tc:GetCounter(0x144b)
				 if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
					Duel.Damage(1-tp,ct*100,REASON_EFFECT)
				 end
			  end
		   else
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			  local tc=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			  if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)~=0 then
				 rsve.addcounter(tp,tc:GetLevel(),nil)
			  end
		   end
	   end
	end
end
