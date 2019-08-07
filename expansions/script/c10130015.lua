--欧米茄
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130015
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	local e1=rscf.SetSummonCondition(c,false)
	aux.AddFusionProcFunRep2(c,cm.ffilter,2,99,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE+LOCATION_GRAVE,0,cm.sprop(c))
	local e2=rsef.SV_IMMUNE_EFFECT(c,cm.val)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0xa336) and c:IsFusionType(TYPE_MONSTER) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function cm.sprop(c)
	return  function(g)
				Duel.Remove(g,POS_FACEUP,REASON_COST)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_BASE_ATTACK)
				e1:SetReset(RESET_EVENT+0xff0000)
				e1:SetValue(#g*800)
				c:RegisterEffect(e1,true)
				local e2=rsef.QO({c,true},nil,{m,0},1,nil,nil,LOCATION_MZONE,nil,nil,cm.copytg,cm.copyop,nil,RESET_EVENT+0xff0000)
			end
end
function cm.val(e,re)
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
	local atk1,atk2=e:GetHandler():GetAttack(),re:GetHandler():GetAttack()
	return atk1>=atk2 and re:GetOwner()~=e:GetOwner()
end
function cm.copyfilter(c,e,tp,eg,ep,ev,re,r,rp)
	local effectlist=c.QuantumDriver_EffectList
	if not effectlist then return false end
	for _,effect in pairs(effectlist) do
		if effect then
			local tg=effect:GetTarget()
			if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
		end
	end
	return false 
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	if chk==0 then return c:IsAttackAbove(800) and mat:IsExists(cm.copyfilter,1,nil,e,tp,eg,ep,ev,re,r,rp) end
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetRelationThisCard(e)
	local mat=c:GetMaterial()
	if not c then return end
	local e1=rsef.SV_UPDATE(c,"atk",-800,nil,rsreset.est_d)
	rsof.SelectHint(tp,HINTMSG_FMATERIAL)
	local tc=mat:FilterSelect(tp,cm.copyfilter,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if not tc then return false end
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	local effectlist=tc.QuantumDriver_EffectList   
	local hintlist={}
	local effectlist2={}
	for _,effect in pairs(effectlist) do 
		if effect then
			local tg=effect:GetTarget()
			if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then 
				table.insert(hintlist,effect:GetDescription())
				table.insert(effectlist2,effect)
			end
		end
	end 
	rsof.SelectHint(tp,aux.Stringid(m,1))
	local op=Duel.SelectOption(tp,table.unpack(hintlist))+1
	local effect=effectlist2[op]
	Duel.Hint(HINT_OPSELECTED,1-tp,effect:GetDescription())
	local op=effect:GetOperation()
	op(e,tp,eg,ep,ev,re,r,rp)
end