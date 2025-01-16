local m=53727008
local cm=_G["c"..m]
cm.name="记忆扩充精灵"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	if not cm.check then
		cm.check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetOperation(cm.chainop)
		Duel.RegisterEffect(e1,0)
		local f1=Card.CheckFusionMaterial
		function Card.CheckFusionMaterial(card,Group_fus,Card_g,int_chkf,not_mat)
			local exg=Group.CreateGroup()
			exg=Duel.GetMatchingGroup(cm.filter0,int_chkf,0,LOCATION_MZONE,nil,card)
			exg=Group.__bxor(exg,Group_fus):Filter(Card.IsLocation,nil,LOCATION_MZONE)
			if exg:GetCount()>0 then
				if Duel.GetFlagEffect(0,m)~=0 and Duel.GetFlagEffect(0,m+50)==0 then
					Duel.RegisterFlagEffect(0,m+50,RESET_CHAIN,0,1)
					local e1=Effect.CreateEffect(card)
					e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
					e1:SetCode(EVENT_CHAIN_SOLVED)
					e1:SetOperation(cm.resetop)
					e1:SetReset(RESET_EVENT+RESET_CHAIN)
					Duel.RegisterEffect(e1,0)
					local e2=e1:Clone()
					e2:SetCode(EVENT_CHAIN_NEGATED)
					Duel.RegisterEffect(e2,0)
				end
				local hg=Group.__add(exg,Group_fus)
				return f1(card,hg,Card_g,int_chkf,not_mat)
			end
			return f1(card,Group_fus,Card_g,int_chkf,not_mat)
		end
		local f2=Duel.SelectFusionMaterial
		function Duel.SelectFusionMaterial(tp,card,mg,gc_nil,chkf)
			if Duel.GetFlagEffect(0,m+50)~=0 then
				exg=Duel.GetMatchingGroup(cm.filter0,int_chkf,LOCATION_MZONE,0,nil,card)
				if exg:GetCount()>0 then
					mg:Merge(exg)
				end
			end
			Duel.ResetFlagEffect(0,m+50)
			return f2(tp,card,mg,gc_nil,chkf)
		end
	end
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1)
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,m+50)
	e:Reset()
end
function cm.filter0(c,fc)
	return c:GetFlagEffect(m)>0 and c:IsCanBeFusionMaterial(fc)
end
function cm.thfilter(c)
	return c:IsCode(53727001) and c:IsAbleToHand()
end
function cm.slfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,m+25)==0
	local b2=Duel.IsExistingMatchingCard(cm.slfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,m+75)==0
	if chk==0 then return b1 or b2 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,m+25)==0
	local b2=Duel.IsExistingMatchingCard(cm.slfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,m+75)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1)) elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.RegisterFlagEffect(tp,m+25,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELF)
		local tc=Duel.SelectMatchingCard(1-tp,cm.slfilter,1-tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,m+75,RESET_PHASE+PHASE_END,0,1)
	end
end
