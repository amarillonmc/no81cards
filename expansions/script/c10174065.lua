--祝祷女祭司
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174065)
function cm.initial_effect(c)
	local e1=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,m},"se,th","de,dsp",nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e2=rsef.I(c,{m,1},{1,m+100},nil,nil,LOCATION_MZONE,nil,rscost.reglabel(100),cm.cptg,cm.cpop)
end
function cm.thfilter(c)
	return c:IsComplexType(TYPE_RITUAL+TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.cpfilter(c)
	return c:IsComplexType(TYPE_SPELL+TYPE_RITUAL) and c:CheckActivateEffect(false,true,false)~=nil and ((c:IsLocation(LOCATION_HAND) and not c:IsPublic()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()))
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.cpfilter,tp,rsloc.hg,0,1,nil)
	end
	e:SetLabel(0)
	rshint.Select(tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,rsloc.hg,0,1,1,nil):GetFirst()
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	if tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
