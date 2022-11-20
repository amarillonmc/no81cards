--暴君恐兽
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174059)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,10,2,cm.ovfilter,aux.Stringid(m,0))
	local e1=rsef.I(c,{m,1},nil,"des,dam",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target(cm.desfilter,"des",LOCATION_HAND+LOCATION_MZONE),cm.desop)
end
function cm.ovfilter(c)
	return c:IsFaceup() and (c:IsRankAbove(5) or c:IsLevelAbove(5)) and not c:IsCode(m) and c:IsRace(RACE_DINOSAUR)
end
function cm.desfilter(c)
	return c:IsRace(RACE_DINOSAUR) and (c:IsFaceup() or not c:IsOnField())
end
function cm.desop(e,tp)
	if rsop.SelectDestroy(tp,cm.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,{})<=0 then return end
	local c=rscf.GetFaceUpSelf(e)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local op=rsop.SelectOption(tp,true,{m,2},#g>0,{m,3},c and true or false,{m,4})
	if op==1 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	elseif op==2 then
		rsop.SelectDestroy(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
	elseif op==3 then
		if c:GetFlagEffect(m)<=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(0)
			e1:SetReset(rsreset.est)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(m,rsreset.est,0,1)
			e:SetLabelObject(e1)
		end
		local ce=e:GetLabelObject()
		local ct=ce:GetValue()+1
		ce:SetValue(ct)
		c:SetHint(CHINT_NUMBER,ct)
	end
end