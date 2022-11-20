--薪王们的化身
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171012)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=rsef.I(c,{m,0},nil,"se,th",nil,LOCATION_HAND,nil,rsds.cost1,rsop.target2(cm.fun,cm.thfilter,"th",rsloc.dg),cm.thop)
	local e2=rsef.QO(c,nil,{m,1},{1,m},nil,nil,LOCATION_MZONE,nil,nil,cm.antg,cm.anop)
	local e3=rsef.I(c,{m,2},{1,m+100},"sp",nil,LOCATION_GRAVE,nil,rsds.cost2(2),rsop.target(rscf.spfilter2(),"sp"),cm.spop)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thfilter(c,e,tp)
	return c:IsCode(m-11) and c:IsAbleToHand() and (c:IsLocation(LOCATION_DECK) or Duel.IsPlayerAffectedByEffect(tp,10171024))
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,rsloc.dg,0,1,1,nil,{},e,tp)
end
function cm.antg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local code=c:GetCode()
	getmetatable(c).announce_filter={ 0xc335,OPCODE_ISSETCARD,code,OPCODE_ISCODE,OPCODE_NOT,TYPE_FUSION,OPCODE_ISTYPE,OPCODE_AND,OPCODE_AND }
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(c).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.Hint(HINT_CARD,0,ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.anop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	c:SetHint(CHINT_CARD,ac)
	local cid=c:CopyEffect(ac,rsreset.est_pend,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(rshint.rstcp)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(rsreset.est_pend)
	e1:SetLabel(cid)
	e1:SetOperation(cm.rstop)
	c:RegisterEffect(e1)
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:SetHint(CHINT_CARD,0)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.mat_group_check(g)
	if not c10171018.checkeffect then return true end
	local og=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	return #g<=0 or g:IsExists(Card.IsCode,1,nil,m-11)
end
