local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	if not s.globle_check then
		s.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.chainop)
		Duel.RegisterEffect(ge1,0)
		local f1=Card.CheckFusionMaterial
		s.fusg=Group.CreateGroup
		s.chaineffect=nil
		function Card.CheckFusionMaterial(card,Group_fus,Card_g,int_chkf,not_mat)
			local exg=Group.CreateGroup()
			s.fusg=Group.CreateGroup()
			if card:GetOriginalCode()==id then
				local tp=card:GetControler()
				local fc=aux.FCheckAdditional or aux.TRUE
				local gc=aux.GCheckAdditional or aux.TRUE
				aux.FCheckAdditional=function(fchk_tp,fchk_sg,fchk_fc)
					return fc(fchk_tp,fchk_sg,fchk_fc) and fchk_sg:FilterCount(s.filter1,nil,fchk_tp)<=1
				end
				aux.GCheckAdditional=function(tp)
					return  function(gchk_sg)
								return gc(gchk_sg) and gchk_sg:FilterCount(s.filter1,nil,tp)<=1
							end
				end
				exg=Duel.GetMatchingGroup(s.filter0,tp,0,LOCATION_EXTRA,nil,card)
				exg=Group.__bxor(exg,Group_fus):Filter(s.filter1,nil,tp)
				if exg:GetCount()>0 then
					if Duel.GetFlagEffect(0,id)~=0 and Duel.GetFlagEffect(0,id+500)==0 then
						Duel.RegisterFlagEffect(0,id+500,RESET_EVENT+RESET_CHAIN,0,1)
						local e1=Effect.CreateEffect(card)
						e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
						e1:SetCode(EVENT_CHAIN_SOLVED)
						e1:SetLabel(tp)
						e1:SetOperation(s.resetop)
						e1:SetReset(RESET_EVENT+RESET_CHAIN)
						Duel.RegisterEffect(e1,0)
						local e2=e1:Clone()
						e2:SetCode(EVENT_CHAIN_NEGATED)
						Duel.RegisterEffect(e2,0)
					end
					local hg=Group.__add(exg,Group_fus)
					return f1(card,hg,Card_g,int_chkf,not_mat)
				end
			end
			return f1(card,Group_fus,Card_g,int_chkf,not_mat)
		end
		local f2=Duel.SelectFusionMaterial
		function Duel.SelectFusionMaterial(tp,card,mg,gc_nil,chkf)
			if card:GetOriginalCode()==id and Duel.GetFlagEffect(0,id)~=0 and Duel.GetFlagEffect(0,id+500)~=0 then
				local exg=Duel.GetMatchingGroup(s.filter0,tp,0,LOCATION_EXTRA,nil,card,s.chaineffect)
				if exg:GetCount()>0 then
					Duel.ConfirmCards(1-tp,exg)
					mg:Merge(exg)
					s.fusg=exg
				end
			end
			Duel.ResetFlagEffect(0,id+500)
			return f2(tp,card,mg,gc_nil,chkf)
		end
	end
end
function s.ffilter(c)
	return c:IsFusionType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	s.chaineffect=re
	Duel.RegisterFlagEffect(0,id,RESET_EVENT+RESET_CHAIN,0,1)
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetCode()==EVENT_CHAIN_SOLVED then Duel.ShuffleExtra(1-e:GetLabel()) end
	Duel.ResetFlagEffect(0,id)
	s.chaineffect=nil
	e:Reset()
end
function s.filter0(c,fc,e)
	return c:IsFacedown() and c:IsCanBeFusionMaterial(fc) and (not e or not c:IsImmuneToEffect(e))
end
function s.filter1(c,tp)
	return c:IsFacedown() and c:IsLocation(LOCATION_EXTRA) and c:IsControler(1-tp)
end
function s.tgfilter(c,type)
	return not c:IsType(type) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.thfilter(c)
	return c:IsAttack(0) and c:IsDefense(0) and c:IsLevel(1) and c:IsAbleToHand()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,0) and Duel.GetFlagEffect(tp,id+498)==0
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,id+499)==0
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.IsPlayerCanDiscardDeck(1-tp,1) and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(1-tp,s.filter,1-tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoGrave(g,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_GRAVE) then return end
	local type=g:GetFirst():GetType()&0x7
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsPlayerCanSendtoGrave(tp) and Duel.GetFlagEffect(tp,id+498)==0
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsPlayerCanSendtoHand(tp) and Duel.GetFlagEffect(tp,id+499)==0
	local op=aux.SelectFromOptions(1-tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)})
	if not op or op==0 then return end
	Duel.RegisterFlagEffect(tp,id+op+497,RESET_PHASE+PHASE_END,0,1)
	Duel.BreakEffect()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,type)
		if #tg>0 then Duel.SendtoGrave(tg,REASON_EFFECT) end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		if #sg>0 then Duel.ConfirmCards(1-tp,sg) end
	end
end
