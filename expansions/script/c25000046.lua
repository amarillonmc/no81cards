--合成异生兽 依组麦儒
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000046)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	rssb.LinkSummonFun(c,4) 
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"dam","ptg,de,dsp",cm.linkcon(2),nil,rsop.target(nil,"dam",0,cm.damval),cm.damop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},nil,"des","de,dsp",cm.linkcon(3),nil,rsop.target(aux.TRUE,"des",0,LOCATION_ONFIELD),cm.desop)
	local e3=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,2},nil,"rm","de,dsp",cm.linkcon(4),nil,cm.rmtg,cm.rmop)
	local e4=rsef.QO(c,nil,{m,3},1,nil,nil,LOCATION_MZONE,nil,cm.cpcost,nil,cm.cpop)
end
function cm.linkcon(ct)
	return function(e)
		local c=e:GetHandler()
		return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetMaterial() and c:GetMaterialCount()>=ct
	end
end
function cm.damval(e,tp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)*200
end 
function cm.damop(e,tp)
	local dam=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)*200
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,dam,REASON_EFFECT)
end
function cm.desop(e,tp)
	rsop.SelectDestroy(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil,{})
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,5)
	if chk==0 then return g:FilterCount(rssb.rmfilter,nil)==5 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.rmop(e,tp)
	local g=Duel.GetDecktopGroup(1-tp,5)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function cm.cpfilter(c)
	return rssb.IsSetM(c) and not c:IsCode(m) 
end
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>0 and g:IsExists(cm.cpfilter,1,nil) end
	Duel.ConfirmCards(1-tp,g)
	local tc=g:FilterSelect(tp,cm.cpfilter,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
	e:SetLabelObject(tc)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local code=tc:GetOriginalCodeRule()
		local cid=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,4))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		e2:SetLabel(cid)
		e2:SetOperation(cm.rstop)
		c:RegisterEffect(e2)
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
