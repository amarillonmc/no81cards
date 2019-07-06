--动物朋友 地狱三头犬
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700937
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,aux.FilterBoolFunction(Card.IsLevel,5),cm.xyzcheck,3,3,cm.ovfilter,aux.Stringid(m,2))
	local f=function(e)
		return Duel.IsAbleToEnterBP()
	end
	local e1=rsef.I(c,{m,0},1,nil,nil,LOCATION_MZONE,f,rscost.rmxyzs(true),nil,cm.op)
	local e2=rsef.STO(c,EVENT_BATTLE_DESTROYING,{m,1},nil,nil,"de",cm.xyzcon,nil,cm.xyztg,cm.xyzop)
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabelObject(tc)
	return tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,tc)
	end
end
function cm.ovfilter(c)
	return c:IsFaceup() and not c:IsCode(m)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==3
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if c then 
		local e1=rsef.SV(c,EFFECT_EXTRA_ATTACK,e:GetLabel())
		e1:SetReset(rsreset.est_pend)
	end
end
