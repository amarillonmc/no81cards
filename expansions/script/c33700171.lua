--动物朋友 飞棍
function c33700171.initial_effect(c)
	 c:EnableReviveLimit() 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c33700171.syncon)
	e0:SetOperation(c33700171.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	 --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33700171.con)
	e1:SetValue(1)
	c:RegisterEffect(e1)
   local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33700171.con)
	e2:SetValue(c33700171.efilter)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700171,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCondition(c33700171.tgcon)
	e3:SetTarget(c33700171.tg)
	e3:SetOperation(c33700171.op)
	c:RegisterEffect(e3)
end
function c33700171.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) 
end
function c33700171.synfilter1(c,syncard,lv,g)
	return c:IsType(TYPE_TUNER) and  g:IsExists(c33700171.synfilter2,1,c,syncard,lv,g,c)
end
function c33700171.lvfilter(c,lv,g)
	return c:IsNotTuner(nil)(nil) and c:GetLevel()<lv and c:IsType(TYPE_MONSTER)
	and c:IsCanBeSynchroMaterial(g)
end
function c33700171.synfilter2(c,syncard,lv,g,mc)
   local tg 
  local mg=g:Filter(c33700171.lvfilter,nil,mc:GetLevel(),syncard)
	if  mc:IsHasEffect(EFFECT_HAND_SYNCHRO) then
	tg=Duel.GetMatchingGroup(c33700171.lvfilter,tp,LOCATION_HAND,0,nil,mc:GetLevel(),syncard)
	 mg:Merge(tg)
end
	Duel.SetSelectedCard(Group.FromCards(c,mc))
	return mg:CheckWithSumEqual(Card.GetSynchroLevel,lv,1,1,syncard)
end
function c33700171.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c33700171.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then
	return c33700171.synfilter1(tuner,c,lv,mg) end
	return mg:IsExists(c33700171.synfilter1,1,nil,c,lv,mg)
end
function c33700171.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c33700171.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	local m1=tuner
   local tg
	if not tuner then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=mg:FilterSelect(tp,c33700171.synfilter1,1,1,nil,c,lv,mg)
		m1=t1:GetFirst()
		g:AddCard(m1)
	end
  if  m1:IsHasEffect(EFFECT_HAND_SYNCHRO) then
	tg=Duel.GetMatchingGroup(c33700171.lvfilter,tp,LOCATION_HAND,0,nil,m1:GetLevel(),c)
	 mg:Merge(tg)
end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local t2=mg:FilterSelect(tp,c33700171.synfilter2,1,1,m1,c,lv,mg,m1)
	g:Merge(t2)
	local mg2=mg:Filter(Card.IsNotTuner(nil),nil)
	Duel.SetSelectedCard(g)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c33700171.con(e)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),0,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetCode)<g:GetCount()
end
function c33700171.efilter(e,re,rp)
	if re:GetOwnerPlayer()==e:GetOwnerPlayer() then return false end 
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function c33700171.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d==e:GetHandler() then d=Duel.GetAttacker() end
	e:SetLabelObject(d)
	return d~=nil
end
function c33700171.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetLabelObject(),1,0,0)
end
function c33700171.desop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33700171,1))
	local coin=Duel.SelectOption(tp,60,61)
	local res=Duel.TossCoin(tp,1)
	if coin==res then
	 local d=e:GetLabelObject()
	if d:IsRelateToBattle() then
		Duel.SendtoGrave(d,REASON_EFFECT)
	end
	end
end
