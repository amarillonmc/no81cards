--电脑魔神 戴斯法萨
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000098)
function cm.initial_effect(c)  
	c:EnableReviveLimit(c)
	aux.AddLinkProcedure(c,nil,2,3,cm.gcheck)
	local e1=rsef.FV_EXTRA_MATERIAL_SELF(c,"link",cm.val,cm.tg,{LOCATION_HAND,0})
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"eq","de,dsp",rscon.sumtype("link"),nil,rsop.target(cm.eqfilter,"eq",LOCATION_DECK),cm.eqop)
	local e3=rsef.I(c,{m,1},{1,m+100},"dam","ptg",nil,rscost.reglabel(100),cm.damtg,cm.damop)
	local e4=rsef.STO(c,EVENT_LEAVE_FIELD,{m,2},{1,m+200},"se,th","de,dsp",cm.thcon,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.thcon(e,tp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function cm.thfilter(c)
	return c:IsCode(25000099) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_SZONE,0,1,nil) end
	local ct=rsop.SelectRemove(tp,cm.tgfilter,tp,LOCATION_SZONE,0,1,99,{POS_FACEUP,REASON_COST })
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*1000) 
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function cm.damop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function cm.gcheck(g)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_MACHINE)
end 
function cm.val(e,c,mg)
	return c==e:GetHandler() and not mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
end
function cm.eqfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp)
end
function cm.eqop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	rsop.SelectSolve(HINTMSG_EQUIP,tp,cm.eqfilter,tp,LOCATION_DECK,0,1,1,nil,cm.eqfun,e,tp)
end
function cm.eqfun(g,e,tp)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	local race=tc:GetRace()
	if rsop.Equip(e,tc,c) then
		local e1=rsef.FV_CANNOT_BE_TARGET({c,tc,true},"effect",aux.tgoval,cm.tg,{LOCATION_MZONE,0},cm.con,rsreset.est)
		e1:SetLabelObject(c)
		e1:SetLabel(race)
	end
	return true
end
function cm.tg(e,c)
	return c:IsRace(e:GetLabel())
end
function cm.con(e,tp)
	return e:GetHandler():GetEquipTarget()==e:GetLabelObject()
end