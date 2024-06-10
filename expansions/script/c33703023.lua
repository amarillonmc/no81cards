--飞空神秘大鱼
local s,id,o=GetID()
function c33703023.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33703023.cost)
	e1:SetTarget(c33703023.target)
	e1:SetOperation(c33703023.operation)
	c:RegisterEffect()
	if not c33703023.global_check then
		c33703023.global_check=true 
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c33703023.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33703023.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local rc=re:GetHandler()
	while tc do 
		if 1-tp==e:GetHandler():GetOwner() and tc:IsType(TYPE_MONSTER) then
			c:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c33703023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 0 end
	Duel.ConfirmCards(1-tp,c)
end
function c33703023.filter(c,num)
	local num=Duel.GetFlagEffect(c,id+o)
	if Duel.GetFlagEffect(c,id+o)>=7 then
		return (c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==num) or (c:IsType(TYPE_SPELL) and c:IsAbleToGrave() and c:CheckActivateEffect(true,true,false)~=nil)
	else 
		return c:GetLevel()==num and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
end
function c33703023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33703023.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,nil,3300)
end
function c33703023.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	if Duel.GetFlagEffect(c,id+o)>=7 then
		c33703023.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_TRAP,OPCODE_ISTYPE,OPCODE_NOT}
	else 
		c33703023.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_TRAP+TYPE_SPELL,OPCODE_ISTYPE,OPCODE_NOT}
	end
	local ac=Duel.AnnounceCard(tp,table.unpack(c33703023.announce_filter))
--质疑的场合，展示自己的卡组，必须将1张宣言的卡名的卡送去墓地，对方受到3300伤害。没有送去墓地的场合，自己受到3300伤害，这张卡除外 
	if Duel.SelectYesNo(tp,aux.Stringid(33703023,0)) then
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		Duel.ConfirmCards(1-tp,g)
		if Duel.SendtoGrave(ac,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,3300,REASON_EFFECT)
		else
			Duel.Damage(tp,3300,REASON_EFFECT)
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		end
	else
--没有质疑的场合，这张卡变成那个宣言的怪兽的同名卡，那些卡名·效果·等级·攻击力·守备力适用并特殊召唤。
--或者这张卡变成那个宣言的魔法卡的同名卡，那张卡发动的效果适用，这张卡送去墓地。
		local code=ac:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
		local lv=ac:GetLevel()
		local atk=ac:GetBaseAttack()
		local def=ac:GetBaseDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(code)
			c:RegisterEffect(e1)

		if ac:IsType(TYPE_MONSTER) then
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(lv)
			c:RegisterEffect(e2)

			local e3=e1:Clone()
			e3:SetCode(EFFECT_SET_BASE_ATTACK)
			e3:SetValue(atk)
			c:RegisterEffect(e3)
			
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_DEFENSE)
			e4:SetValue(def)
			c:RegisterEffect(e4)
			
			local e5=Effect.CreateEffect(c)
			e5:SetDescription(aux.Stringid(33703023,3))
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e5:SetCode(EVENT_PHASE+PHASE_END)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCountLimit(1)
			e5:SetLabelObject(e1)
			e5:SetLabel(cid)
			e5:SetOperation(c33703023.rstop)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e5)
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		else
			local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
			e:SetProperty(te:GetProperty())
			if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
			te:SetLabelObject(e:GetLabelObject())
			e:SetLabelObject(te)
			Duel.ClearOperationInfo(0)
			local te=e:GetLabelObject()
			if te then
				e:SetLabelObject(te:GetLabelObject())
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
			Duel.BreakEffect()
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end
end
function c33703023.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

