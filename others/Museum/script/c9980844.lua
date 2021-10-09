--魔法骑士wizard·完全魔龙
function c9980844.initial_effect(c)
   aux.EnablePendulumAttribute(c,false)
   c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9980844.matfilter,4,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD+LOCATION_GRAVE,0,c9980844.sprop(c))
   --indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c9980844.indtg)
	e2:SetValue(c9980844.indct)
	c:RegisterEffect(e2)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980844,3))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c9980844.drcon)
	e4:SetTarget(c9980844.drtg)
	e4:SetOperation(c9980844.drop)
	c:RegisterEffect(e4)
	if not c9980844.global_check then
		c9980844.global_check=true
		c9980844[0]=0
		c9980844[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c9980844.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c9980844.clearop)
		Duel.RegisterEffect(ge2,0)
	end
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980844,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,9980844)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9980844.negcon)
	e3:SetTarget(c9980844.negtg)
	e3:SetOperation(c9980844.negop)
	c:RegisterEffect(e3)
   --set
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c9980844.pcon)
	e6:SetTarget(c9980844.ptg)
	e6:SetOperation(c9980844.pop)
	c:RegisterEffect(e6)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980844.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980844.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980844,4))
end
function c9980844.indtg(e,c)
	return c:IsRace(RACE_SPELLCASTER+RACE_DRAGON)
end
function c9980844.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)==0 then return 0 end
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local tc=a:GetBattleTarget()
	if tc and tc:IsControler(1-tp) then a,tc=tc,a end
	local dam=Duel.GetBattleDamage(tp)
	if not tc or dam<=0 then return 1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(dam)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	return 1
end
function c9980844.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x5bc2) and tc:IsSummonType(SUMMON_TYPE_RITUAL) then
			local p=tc:GetSummonPlayer()
			c9980844[p]=c9980844[p]+1
		end
		tc=eg:GetNext()
	end
end
function c9980844.clearop(e,tp,eg,ep,ev,re,r,rp)
	c9980844[0]=0
	c9980844[1]=0
end
function c9980844.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c9980844[tp]>0
end
function c9980844.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c9980844[tp]) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c9980844[tp])
end
function c9980844.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,c9980844[tp],REASON_EFFECT)
end

function c9980844.matfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsFusionSetCard(0x5bc2)
end
function c9980844.sprop(c)
	return  function(g)
				Duel.Remove(g,POS_FACEUP,REASON_COST)
				local e1=rsef.QO({c,true},nil,{9980844,0},{1,99808440},nil,nil,LOCATION_ONFIELD,nil,nil,c9980844.copytg,c9980844.copyop,nil,RESET_EVENT+0xff0000)
			end
end
function c9980844.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 and rp==1-tp
end
function c9980844.checkchain(ev,tp,e)
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if p~=tp then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if e then
				if Duel.NegateActivation(i) and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
					dg:AddCard(tc)
				end
			else
				if tc:IsRelateToEffect(te) then
					dg:AddCard(tc)
				end
			end
		end
	end
	return ng,dg
end
function c9980844.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng,dg=c9980844.checkchain(ev,tp)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,#ng,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function c9980844.negop(e,tp,eg,ep,ev,re,r,rp)
	local ng,dg=c9980844.checkchain(ev,tp,e)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c9980844.copyfilter(c,e,tp,eg,ep,ev,re,r,rp)
	local effectlist=c.QuantumDriver_EffectList
	if not effectlist then return false end
	for _,effect in pairs(effectlist) do
		if effect then
			local tg=effect:GetTarget()
			if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
		end
	end
	return false 
end
function c9980844.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	if chk==0 then return mat:IsExists(c9980844.copyfilter,1,nil,e,tp,eg,ep,ev,re,r,rp) end
end
function c9980844.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetRelationThisCard(e)
	local mat=c:GetMaterial()
	if not c then return end
	local e1=rsef.SV_UPDATE(c,"atk",300,nil,rsreset.est_d)
	rsof.SelectHint(tp,HINTMSG_FMATERIAL)
	local tc=mat:FilterSelect(tp,c9980844.copyfilter,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if not tc then return false end
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	local effectlist=tc.QuantumDriver_EffectList   
	local hintlist={}
	local effectlist2={}
	for _,effect in pairs(effectlist) do 
		if effect then
			local tg=effect:GetTarget()
			if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then 
				table.insert(hintlist,effect:GetDescription())
				table.insert(effectlist2,effect)
			end
		end
	end 
	rsof.SelectHint(tp,aux.Stringid(9980844,1))
	local op=Duel.SelectOption(tp,table.unpack(hintlist))+1
	local effect=effectlist2[op]
	Duel.Hint(HINT_OPSELECTED,1-tp,effect:GetDescription())
	local op=effect:GetOperation()
	op(e,tp,eg,ep,ev,re,r,rp)
end
function c9980844.pcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_EXTRA
end
function c9980844.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c9980844.pop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end