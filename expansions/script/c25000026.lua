--来自三千万年前的讯息
if not pcall(function() require("expansions/script/c25000024") end) then require("script/c25000024") end
local m,cm=rscf.DefineCard(25000026)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,{m,0},{1,m},"sp,se,th",nil,nil,nil,cm.contg,cm.conop)
	--local e1=rsef.ACT(c,nil,{m,0},{1,m},"sp",nil,nil,nil,rsop.target(rscf.spfilter2(rsoc.IsSet),"sp",LOCATION_DECK),cm.spop)
	--local e2=rsef.ACT(c,nil,{m,1},{1,m},"se,th",nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e3=aux.AddRitualProcGreater2Code2(c,25000031,25000032,nil,nil,aux.TRUE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCost(aux.bfgcost)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m+100)
	e3:SetDescription(aux.Stringid(m,0))
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(cm.handcon)
	c:RegisterEffect(e4)
end
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,rscf.spfilter2(rsoc.IsSet),tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end
function cm.thfilter(c)
	return rsoc.IsSetST(c) and c:IsAbleToHand() 
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.confilter(c,e,tp)
	if not c:IsSetCard(0xaf3) then return false end
	return (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.conop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		if g:IsExists(cm.confilter,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
			local tc=g:FilterSelect(tp,cm.confilter,1,1,nil,e,tp):GetFirst()
			if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			else
				rssf.SpecialSummon(tc)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end