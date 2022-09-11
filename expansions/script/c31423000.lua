--last upd 2022-9-1
--if not pcall(function() require("expansions/script/c31423000") end) then require("expansions/script/c31423000") end
Seine_space_ghoti={}
local sf=_G["Seine_space_ghoti"]
sf.sfcode=31423001
function sf.to_deck_cost(towhere)
	local seq
	if not towhere then seq=SEQ_DECKSHUFFLE end
	if towhere==1 then seq=SEQ_DECKTOP end
	if towhere==2 then seq=SEQ_DECKBOTTOM end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
		Duel.SendtoDeck(e:GetHandler(),tp,seq,REASON_COST)
	end
end
function sf.sp_proc_con(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(aux.TRUE,c:GetControler(),e:GetLabel(),0,c)==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function sf.add_sp_proc(c,from,nocard)
	if c:GetCode()~=sf.sfcode then
		aux.AddCodeList(c,sf.sfcode)
		aux.EnableChangeCode(c,sf.sfcode,0x1ff)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(from)
	if not from then e1:SetRange(LOCATION_HAND+LOCATION_DECK) end
	e1:SetCondition(sf.sp_proc_con)
	e1:SetLabel(nocard)
	if not nocard then e1:SetLabel(LOCATION_HAND+LOCATION_ONFIELD) end
	c:RegisterEffect(e1)
end
function sf.climax_atk_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function sf.climax_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,num) end
end
function sf.climax_filter(c)
	return c:IsCode(sf.sfcode) or aux.IsCodeListed(c,sf.sfcode)
end
function sf.climax_op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>e:GetLabel() then ct=e:GetLabel() end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	local sg=g:Filter(sf.climax_filter,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
		if Duel.GetAttacker() then Duel.NegateAttack() end
	end
	Duel.ShuffleDeck(tp)
end
function sf.add_climax_e(c,num)
	local code=c:GetCode()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sf.sfcode-1,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(sf.climax_tg)
	e1:SetOperation(sf.climax_op)
	e1:SetLabel(num)
	e1:SetCountLimit(1,code)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(sf.climax_atk_con)
	c:RegisterEffect(e2)
end
function sf.copy_reveal_con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_REVEAL)
end
function sf.copy_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function sf.copy_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) and c:CheckActivateEffect(true,true,false)~=nil
	end
	e:SetLabel(0)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	local te,ceg,cep,cev,cre,cr,crp=c:CheckActivateEffect(true,true,true)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function sf.copy_op(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	e:SetProperty(EFFECT_FLAG_DELAY)
end
function sf.add_copy_e(c)
	local code=c:GetCode()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(sf.copy_cost)
	e1:SetTarget(sf.copy_tg)
	e1:SetOperation(sf.copy_op)
	e1:SetCountLimit(1,code+100000000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(sf.copy_reveal_con)
	c:RegisterEffect(e2)
end
function sf.spell_ini(c,climax_num)
	sf.add_copy_e(c)
	sf.add_climax_e(c,climax_num)
	aux.AddCodeList(c,sf.sfcode)
end