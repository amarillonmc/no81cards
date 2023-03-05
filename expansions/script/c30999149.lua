--王战的君临
function c30999149.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c30999149.target)
	e1:SetOperation(c30999149.activate)
	c:RegisterEffect(e1)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e5)
end
function c30999149.filter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x134) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLevel(9)
end
function c30999149.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dr=Duel.GetMatchingGroupCount(c30999149.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,dr+1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,dr+1)
end
function c30999149.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if not Duel.IsPlayerCanDraw(p) then return end
	local ct=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
	local ct2=Duel.GetMatchingGroupCount(c30999149.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp)
	local ac=0
	if ct==0 then ac=1 end
	if ct>=1 then
		Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(30999149,0))
		if ct2+1>=5 then
			ac=Duel.AnnounceNumber(p,5)
		elseif ct2+1==4 then
			if ct>=5 then
				ac=Duel.AnnounceNumber(p,4,5)
			else
				ac=Duel.AnnounceNumber(p,4)
			end
		elseif ct2+1==3 then
			if ct>=5 then
				ac=Duel.AnnounceNumber(p,3,4,5)
			elseif ct==4 then
				ac=Duel.AnnounceNumber(p,3,4)
			else
				ac=Duel.AnnounceNumber(p,3)
			end
		elseif ct2+1==2 then
			if ct>=5 then
				ac=Duel.AnnounceNumber(p,2,3,4,5)
			elseif ct==4 then
				ac=Duel.AnnounceNumber(p,2,3,4)
			elseif ct==3 then
				ac=Duel.AnnounceNumber(p,2,3)
			else
				ac=Duel.AnnounceNumber(p,2)
			end
		else
			if ct>=5 then
				ac=Duel.AnnounceNumber(p,1,2,3,4,5)
			elseif ct==4 then
				ac=Duel.AnnounceNumber(p,1,2,3,4)
			elseif ct==3 then
				ac=Duel.AnnounceNumber(p,1,2,3)
			elseif ct==2 then
				ac=Duel.AnnounceNumber(p,1,2)
			else
				ac=Duel.AnnounceNumber(p,1)
			end
		end
	end
	local dr=Duel.Draw(p,ac,REASON_EFFECT)
	if p~=tp and dr~=0 then
		if dr>=1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetTargetRange(0xff,0xff)
			e1:SetTarget(c30999149.filter2)
			e1:SetValue(aux.tgoval)
			Duel.RegisterEffect(e1,tp)
			local ge1=Effect.CreateEffect(e:GetHandler())
			ge1:SetDescription(aux.Stringid(30999149,1))
			ge1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			ge1:SetType(EFFECT_TYPE_SINGLE)
			local ge01=Effect.CreateEffect(e:GetHandler())
			ge01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			ge01:SetTargetRange(0xff,0xff)
			ge01:SetTarget(c30999149.filter2)
			ge01:SetLabelObject(ge1)
			Duel.RegisterEffect(ge01,tp)
		end
		if dr>=2 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(30999149,2))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetTargetRange(0xff,0xff)
			e2:SetTarget(c30999149.filter2)
			e2:SetValue(1)
			Duel.RegisterEffect(e2,tp)
			local ge2=Effect.CreateEffect(e:GetHandler())
			ge2:SetDescription(aux.Stringid(30999149,2))
			ge2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			ge2:SetType(EFFECT_TYPE_SINGLE)
			local ge02=Effect.CreateEffect(e:GetHandler())
			ge02:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			ge02:SetTargetRange(0xff,0xff)
			ge02:SetTarget(c30999149.filter2)
			ge02:SetLabelObject(ge2)
			Duel.RegisterEffect(ge02,tp)
		end
		if dr>=3 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(30999149,3))
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetTargetRange(0xff,0xff)
			e3:SetTarget(c30999149.filter2)
			e3:SetValue(1)
			Duel.RegisterEffect(e3,tp)
			local ge3=Effect.CreateEffect(e:GetHandler())
			ge3:SetDescription(aux.Stringid(30999149,3))
			ge3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			ge3:SetType(EFFECT_TYPE_SINGLE)
			local ge03=Effect.CreateEffect(e:GetHandler())
			ge03:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			ge03:SetTargetRange(0xff,0xff)
			ge03:SetTarget(c30999149.filter2)
			ge03:SetLabelObject(ge3)
			Duel.RegisterEffect(ge03,tp)
		end
		if dr>=4 then
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetDescription(aux.Stringid(30999149,4))
			e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DIRECT_ATTACK)
			e4:SetTargetRange(0xff,0xff)
			e4:SetTarget(c30999149.filter2)
			Duel.RegisterEffect(e4,tp)
			local ge4=Effect.CreateEffect(e:GetHandler())
			ge4:SetDescription(aux.Stringid(30999149,4))
			ge4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			ge4:SetType(EFFECT_TYPE_SINGLE)
			local ge04=Effect.CreateEffect(e:GetHandler())
			ge04:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			ge04:SetTargetRange(0xff,0xff)
			ge04:SetTarget(c30999149.filter2)
			ge04:SetLabelObject(ge4)
			Duel.RegisterEffect(ge04,tp)
		end
		if dr>=5 then
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetDescription(aux.Stringid(30999149,5))
			e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetCode(EFFECT_SET_ATTACK_FINAL)
			e5:SetTargetRange(0xff,0xff)
			e5:SetTarget(c30999149.filter2)
			e5:SetValue(10000)
			Duel.RegisterEffect(e5,tp)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
			Duel.RegisterEffect(e6,tp)
			local ge5=Effect.CreateEffect(e:GetHandler())
			ge5:SetDescription(aux.Stringid(30999149,5))
			ge5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			ge5:SetType(EFFECT_TYPE_SINGLE)
			local ge05=Effect.CreateEffect(e:GetHandler())
			ge05:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			ge05:SetTargetRange(0xff,0xff)
			ge05:SetTarget(c30999149.filter2)
			ge05:SetLabelObject(ge5)
			Duel.RegisterEffect(ge05,tp)
		end
	end
end
function c30999149.filter2(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and c:IsSetCard(0x134) and c:IsFaceup() 
end
