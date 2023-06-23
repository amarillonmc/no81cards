--无限的未完成
local s,id,o=GetID()
function s.initial_effect(c)
	if not iroha then
		iroha=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetRange(0xff)
		e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
		e1:SetOperation(s.op)
		Duel.RegisterEffect(e1,0)
		_CreateToken=Duel.CreateToken
		function Duel.CreateToken(p,code)
			local c =_CreateToken(p,code)
			s.changecode(c)
			return c
		end
		function aux.IsCodeListed(c,code)
			return false
		end
		function Duel.Win(p,r)
		
		end
	end
end
function s.changecode(tc)
	--local cid=tc:GetOriginalCode()
	local cid=0
	local Type=tc:GetOriginalType()
	if Type&TYPE_MONSTER>0 then		  
		if Type&TYPE_NORMAL>0 then cid=id+1 end
		if Type&TYPE_LINK>0 then cid=id+10+tc:GetLink() end  --
		if Type&TYPE_SYNCHRO>0 then cid=id+3 end
		if Type&TYPE_XYZ>0 then cid=id+5 end
		if Type&TYPE_RITUAL>0 then cid=id+7 end
		if Type&TYPE_FUSION>0 then cid=id+9 end
		if Type&TYPE_PENDULUM>0 then cid=cid+1 end
		if cid>id+39 or cid<id+1 then cid=id+1 end
		if Type&TYPE_TOKEN>0 then cid=id+39 end  
		tc:SetCardData(CARDDATA_CODE,cid)
	else 
		if Type&TYPE_SPELL>0 then
			tc:SetCardData(CARDDATA_CODE,id+20)
			if Type&TYPE_QUICKPLAY>0 then tc:SetCardData(CARDDATA_CODE,id+21) end
			if Type&TYPE_CONTINUOUS>0 then tc:SetCardData(CARDDATA_CODE,id+22) end
			if Type&TYPE_EQUIP>0 then tc:SetCardData(CARDDATA_CODE,id+23) end
			if Type&TYPE_FIELD>0 then tc:SetCardData(CARDDATA_CODE,id+24) end
			if Type&TYPE_RITUAL>0 then tc:SetCardData(CARDDATA_CODE,id+25) end
		else 
			if Type&TYPE_TRAP>0 then
				tc:SetCardData(CARDDATA_CODE,id+30)
				if Type&TYPE_CONTINUOUS>0 then tc:SetCardData(CARDDATA_CODE,id+31) end
				if Type&TYPE_COUNTER>0 then tc:SetCardData(CARDDATA_CODE,id+32) end
			end
		end
	end
end
--function s.changemonster(c,Type,Lkm,Lv,Rk,Att,Atk,Def,Race,Lsc,Rsc)
--	local e1=Effect.CreateEffect(c)
--	e1:SetType(EFFECT_TYPE_SINGLE)
--	e1:SetCode(EFFECT_SET_BASE_ATTACK)
--	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
--	e1:SetRange(0xff)
--	e1:SetValue(Atk)
--	c:RegisterEffect(e1)
--	local e2=e1:Clone()
--	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
--	e2:SetValue(Def)
--	c:RegisterEffect(e2)
--	local e3=Effect.CreateEffect(c)
--	e3:SetType(EFFECT_TYPE_SINGLE)
--	e3:SetCode(EFFECT_CHANGE_TYPE)
--	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
--	e3:SetValue(Type)
--	e3:SetReset(0)
--	c:RegisterEffect(e3)	
--	local e4=e1:Clone()
--	e4:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
--	e4:SetValue(Lkm)
--	c:RegisterEffect(e4)  
--	local e5=e1:Clone()
--	e5:SetCode(EFFECT_CHANGE_LEVEL)
--	e5:SetValue(Lv)
--	c:RegisterEffect(e5)
--	local e6=e1:Clone()
--	e6:SetCode(EFFECT_CHANGE_RANK)
--   e6:SetValue(Rk)
--	c:RegisterEffect(e6)
--	local e7=e1:Clone()
--	e7:SetCode(EFFECT_CHANGE_ATTRIBUTE)
--	e7:SetValue(Att)
--	c:RegisterEffect(e7)
--	local e8=e1:Clone()
--	e8:SetCode(EFFECT_CHANGE_RACE)
--   e8:SetValue(Race)
--	c:RegisterEffect(e8)
--	local e9=e1:Clone()
--	e9:SetCode(EFFECT_CHANGE_LSCALE)
--	e9:SetValue(Lsc)
--	c:RegisterEffect(e9)
--	local e10=e1:Clone()
--	e10:SetCode(EFFECT_CHANGE_RSCALE)
--	e10:SetValue(Rsc)
--	c:RegisterEffect(e10)
--end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_CARD,1-tp,id)
	local tg=Duel.GetFieldGroup(tp,0xff,0xff)
	if tg then 
		for tc in aux.Next(tg) do
			s.changecode(tc)
		end
		Duel.Draw(tp,Duel.SendtoDeck(Duel.GetFieldGroup(tp,LOCATION_HAND,0),nil,SEQ_DECKSHUFFLE,REASON_RULE),REASON_RULE)
		Duel.Draw(1-tp,Duel.SendtoDeck(Duel.GetFieldGroup(1-tp,LOCATION_HAND,0),nil,SEQ_DECKSHUFFLE,REASON_RULE),REASON_RULE)
		local rg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA)
		Duel.Remove(rg,POS_FACEDOWN,REASON_RULE)
		Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	function Card.SetEntityCode(c,bool)

	end
	_SetCardData=Card.SetCardData
	function Card.SetCardData(c,type,value)
		if type==CARDDATA_CODE then return end
		_SetCardData(c,type,value)
	end
	_Hint=Duel.Hint
	function Duel.Hint(ht,p,desc)
		if ht==HINT_CARD then desc=id+1 end
		_Hint(ht,p,desc)
	end
end